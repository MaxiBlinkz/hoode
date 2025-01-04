from fastapi import FastAPI, HTTPException, Depends, Header
from pocketbase import PocketBase
from typing import Optional, List, Dict
from datetime import datetime
from models.models import (
    UserPreferences, 
    UserInteractionHistory, 
    GeoPoint, 
    MarketTrends,
    SeasonalData
)
from services.property_recommender import PropertyRecommender

app = FastAPI(title="Hoode Property Recommender API")

# PocketBase client configuration
pb = PocketBase('YOUR_POCKETBASE_URL')

async def verify_token(authorization: str = Header(...)) -> str:
    try:
        token = authorization.split(' ')[1]
        pb.auth_store.save_token(token)
        return pb.auth_store.model.id
    except:
        raise HTTPException(
            status_code=401, 
            detail="Invalid authentication credentials"
        )

@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

@app.get("/recommendations/{user_id}")
async def get_recommendations(
    user_id: str, 
    current_user: str = Depends(verify_token)
) -> Dict[str, List]:
    if current_user != user_id:
        raise HTTPException(
            status_code=403, 
            detail="Not authorized to access this user's data"
        )
        
    try:
        # Fetch all required data from PocketBase
        user_data = pb.collection('users').get_one(user_id)
        user_prefs = pb.collection('user_preferences').get_one(
            filter=f'user_id="{user_id}"'
        )
        interactions = pb.collection('user_interactions').get_list(
            filter=f'user_id="{user_id}"',
            expand='property_id'
        )
        all_properties = pb.collection('properties').get_list(
            expand='location,features'
        )
        market_data = pb.collection('market_trends').get_list()
        
        # Transform data to our models
        preferences = UserPreferences(
            target_price=user_prefs.target_price,
            preferred_location=GeoPoint(
                latitude=user_prefs.location.latitude,
                longitude=user_prefs.location.longitude
            ),
            preferred_amenities=user_prefs.amenities,
            preferred_type=user_prefs.property_type
        )
        
        interaction_history = UserInteractionHistory(
            view_counts={i.property_id: i.view_count for i in interactions.items},
            favorites={i.property_id for i in interactions.items if i.is_favorite},
            clicks={i.property_id: [
                datetime.fromisoformat(d) for d in i.click_dates
            ] for i in interactions.items}
        )
        
        market_trends = MarketTrends({
            m.location: {
                'demand': m.demand,
                'price_appreciation': m.price_appreciation,
                'development_score': m.development_score,
                'price_growth': m.price_growth
            } for m in market_data.items
        })
        
        # Get recommendations
        recommendations = PropertyRecommender.get_recommendations(
            all_properties.items,
            preferences,
            interaction_history,
            market_trends,
            SeasonalData()
        )
        
        # Transform recommendations for response
        return {
            "recommendations": [
                {
                    "id": prop.id,
                    "title": prop.title,
                    "price": prop.price,
                    "location": prop.location,
                    "type": prop.type,
                    "features": prop.features,
                    "images": prop.images,
                    "score": prop.recommendation_score
                }
                for prop in recommendations
            ]
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/market-trends")
async def get_market_trends(current_user: str = Depends(verify_token)):
    try:
        trends = pb.collection('market_trends').get_list()
        return {"market_trends": trends.items}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
