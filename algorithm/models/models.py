# -*- coding: utf-8 -*-
"""
Created on Sat Jan  4 19:08:55 2025

@author: maxwe
"""

from pydantic import BaseModel
from typing import List, Dict, Set
from datetime import datetime, timedelta
from enum import Enum

class GeoPoint(BaseModel):
    latitude: float
    longitude: float

class Season(str, Enum):
    SPRING = "spring"
    SUMMER = "summer"
    FALL = "fall"
    WINTER = "winter"

class UserPreferences(BaseModel):
    target_price: float
    preferred_location: GeoPoint
    preferred_amenities: List[str]
    preferred_type: str

class UserInteractionHistory(BaseModel):
    view_counts: Dict[str, int]
    favorites: Set[str]
    clicks: Dict[str, List[datetime]]

    def get_view_count(self, property_id: str) -> int:
        return self.view_counts.get(property_id, 0)

    def is_favorite(self, property_id: str) -> bool:
        return property_id in self.favorites

    def get_recent_clicks(self, property_id: str) -> int:
        property_clicks = self.clicks.get(property_id, [])
        recent = datetime.now() - timedelta(days=7)
        return len([click for click in property_clicks if click > recent])

# Add these classes alongside the existing models

class MarketTrends:
    def get_location_demand(self, location: str) -> float:
        # Using the mock data market trends
        return self.trends.get(location, {}).get('demand', 0.5)
    
    def get_price_appreciation(self, location: str) -> float:
        return self.trends.get(location, {}).get('price_appreciation', 0.5)
    
    def get_development_score(self, location: str) -> float:
        return self.trends.get(location, {}).get('development_score', 0.5)
    
    def get_price_growth(self, location: str) -> float:
        return self.trends.get(location, {}).get('price_growth', 0.05)
    
    def __init__(self, trends_data: dict = None):
        self.trends = trends_data if trends_data else {}

class SeasonalData:
    def get_current_season(self) -> Season:
        month = datetime.now().month
        if 6 <= month <= 8:
            return Season.SUMMER
        elif month == 12 or 1 <= month <= 2:
            return Season.WINTER
        elif 3 <= month <= 5:
            return Season.SPRING
        else:
            return Season.FALL

