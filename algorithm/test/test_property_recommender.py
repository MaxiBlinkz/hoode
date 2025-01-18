# -*- coding: utf-8 -*-
"""
Created on Sat Jan  4 19:24:09 2025

@author: maxwe
"""

import json
from datetime import datetime, timedelta
from models.models import *
from services.property_recommender import PropertyRecommender

def load_mock_data():
    with open('mock_data.json', 'r') as f:
        return json.load(f)

def test_recommendations():
    # Load mock data
    mock_data = load_mock_data()
    
    # Initialize MarketTrends with mock data
    market_trends = MarketTrends(mock_data['market_trends'])
    
    # Convert mock data to appropriate models
    user_prefs = UserPreferences(
        target_price=mock_data['user_preferences']['target_price'],
        preferred_location=GeoPoint(**mock_data['user_preferences']['preferred_location']),
        preferred_amenities=mock_data['user_preferences']['preferred_amenities'],
        preferred_type=mock_data['user_preferences']['preferred_type']
    )
    
    # Convert datetime strings to datetime objects for clicks
    interaction_history = mock_data['interaction_history']
    for prop_id in interaction_history['clicks']:
        interaction_history['clicks'][prop_id] = [
            datetime.fromisoformat(dt) for dt in interaction_history['clicks'][prop_id]
        ]
    
    interactions = UserInteractionHistory(**interaction_history)
    
    # Get recommendations
    recommendations = PropertyRecommender.get_recommendations(
        mock_data['properties'],
        user_prefs,
        interactions,
        market_trends,
        SeasonalData()
    )
    
    # Print results
    print(f"Found {len(recommendations)} recommendations")
    for idx, prop in enumerate(recommendations, 1):
        print(f"\nRecommendation {idx}:")
        print(f"Title: {prop['title']}")
        print(f"Price: ${prop['price']:,.2f}")
        print(f"Type: {prop['type']}")
        print(f"Location: {prop['location']}")
        print(f"Features: {', '.join(prop['features'])}")

if __name__ == "__main__":
    test_recommendations()

