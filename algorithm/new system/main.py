from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel
from typing import List
import uvicorn
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import pandas as pd
from datetime import datetime

app = FastAPI()

class RecommendationRequest(BaseModel):
    user_id: str
    latitude: float
    longitude: float
    properties: List[dict]
    pb_token: Optional[str] = None

class PropertyView(BaseModel):
    user_id: str
    property_id: str

@app.post("/recommendations")
async def get_recommendations(
    request: RecommendationRequest,
    x_pb_token: Optional[str] = Header(None)
):
    try:
        properties_df = pd.DataFrame(request.properties)
        
        recommender = PropertyRecommender()
        recommendations = recommender.get_recommendations(
            request.user_id,
            properties_df,
            request.latitude,
            request.longitude
        )
        
        return recommendations.to_dict('records')
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/similar-properties/{property_id}")
async def get_similar_properties(property_id: str):
    try:
        properties_df = pd.DataFrame()  # Replace with your actual data fetch
        
        # Get similar properties based on features
        similar_properties = get_similar_properties_by_features(
            property_id,
            properties_df
        )
        
        return similar_properties.to_dict('records')
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/track-view")
async def track_property_view(view: PropertyView):
    try:
        # Record the view in your database
        record_property_view(
            user_id=view.user_id,
            property_id=view.property_id,
            timestamp=datetime.now()
        )
        return {"status": "success"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
