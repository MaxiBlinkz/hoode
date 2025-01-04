# -*- coding: utf-8 -*-
"""
Created on Sat Jan  4 19:11:39 2025

@author: maxwe
"""
from typing import List
from datetime import datetime, timedelta
from geopy.distance import geodesic
from models.models import *

class PropertyRecommender:
    LOCATION_WEIGHT = 0.4
    PRICE_WEIGHT = 0.3
    INTERACTION_WEIGHT = 0.15
    SEASONAL_WEIGHT = 0.15
    TREND_WEIGHT = 0.15

    @staticmethod
    def get_recommendations(
        all_properties: List[dict],
        user_prefs: UserPreferences,
        interactions: UserInteractionHistory,
        trends: MarketTrends,
        seasonal: SeasonalData
    ) -> List[dict]:
        scored_properties = [
            (prop, PropertyRecommender._calculate_enhanced_score(
                prop, user_prefs, interactions, trends, seasonal
            )) for prop in all_properties
        ]
        
        scored_properties.sort(key=lambda x: x[1], reverse=True)
        return [prop for prop, _ in scored_properties[:10]]

    @staticmethod
    def _calculate_distance_score(property_location: GeoPoint, preferred_location: GeoPoint) -> float:
        distance = geodesic(
            (property_location.latitude, property_location.longitude),
            (preferred_location.latitude, preferred_location.longitude)
        ).kilometers
        return max(0.0, min(1.0, 1 - (distance / 20)))  # 20km as max relevant distance
    
    @staticmethod
    def _calculate_enhanced_score(
        property: dict,
        user_prefs: UserPreferences,
        interactions: UserInteractionHistory,
        trends: MarketTrends,
        seasonal: SeasonalData
    ) -> float:
        score = 0.0
    
        # Price and market trend analysis
        price_score = PropertyRecommender._calculate_price_score(property, user_prefs, trends)
        score += price_score * PropertyRecommender.PRICE_WEIGHT
    
        # Location scoring
        location_score = PropertyRecommender._calculate_distance_score(
            GeoPoint(**property['geopoint']),
            user_prefs.preferred_location
        )
        score += location_score * PropertyRecommender.LOCATION_WEIGHT
    
        # User interaction history
        interaction_score = PropertyRecommender._calculate_interaction_score(property, interactions)
        score += interaction_score * PropertyRecommender.INTERACTION_WEIGHT
    
        # Seasonal relevance
        seasonal_score = PropertyRecommender._calculate_seasonal_score(property, seasonal)
        score += seasonal_score * PropertyRecommender.SEASONAL_WEIGHT
    
        # Market trends impact
        trend_score = PropertyRecommender._calculate_trend_score(property, trends)
        score += trend_score * PropertyRecommender.TREND_WEIGHT
    
        return score
    
    @staticmethod
    def _calculate_price_score(property: dict, prefs: UserPreferences, trends: MarketTrends) -> float:
        property_price = property['price']
        pref_price = prefs.target_price
        
        score = 1 - (abs(property_price - pref_price) / pref_price)
        price_growth = trends.get_price_growth(property['location'])
        future_value_score = 0.2 if price_growth > 0 else -0.1
        
        return max(0.0, min(1.0, score + future_value_score))
    
    @staticmethod
    def _calculate_interaction_score(property: dict, interactions: UserInteractionHistory) -> float:
        score = 0.0
        prop_id = property['id']
        
        score += min(0.4, interactions.get_view_count(prop_id) / 10)
        if interactions.is_favorite(prop_id):
            score += 0.3
        score += min(0.3, interactions.get_recent_clicks(prop_id) / 5)
        
        return score
    
    @staticmethod
    def _calculate_seasonal_score(property: dict, seasonal: SeasonalData) -> float:
        current_season = seasonal.get_current_season()
        features = property['features']
        score = 0.0
        
        if current_season == Season.SUMMER:
            if 'pool' in features: score += 0.3
            if 'garden' in features: score += 0.2
            if 'balcony' in features: score += 0.2
        
        if current_season == Season.WINTER:
            if 'heating' in features: score += 0.3
            if 'covered_parking' in features: score += 0.2
        
        return min(1.0, score)
    
    @staticmethod
    def _calculate_trend_score(property: dict, trends: MarketTrends) -> float:
        location = property['location']
        score = 0.0
        
        score += trends.get_location_demand(location) * 0.4
        score += trends.get_price_appreciation(location) * 0.3
        score += trends.get_development_score(location) * 0.3
        
        return min(1.0, score)

