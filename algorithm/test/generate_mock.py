# -*- coding: utf-8 -*-
"""
Created on Sat Jan  4 19:22:48 2025

@author: maxwe
"""

from faker import Faker
from datetime import datetime, timedelta
import random
import json
from typing import Dict, List

fake = Faker()

def generate_mock_properties(count: int = 50) -> List[Dict]:
    property_types = ['apartment', 'house', 'villa', 'condo', 'townhouse']
    features = ['pool', 'garden', 'balcony', 'heating', 'covered_parking', 
                'gym', 'security', 'parking', 'elevator', 'furnished']
    
    properties = []
    for _ in range(count):
        property_features = random.sample(features, random.randint(3, 7))
        property = {
            'id': fake.uuid4(),
            'title': fake.catch_phrase(),
            'type': random.choice(property_types),
            'price': round(random.uniform(100000, 1000000), 2),
            'location': fake.city(),
            'geopoint': {
                'latitude': float(fake.latitude()),
                'longitude': float(fake.longitude())
            },
            'features': property_features,
            'square_feet': random.randint(800, 4000),
            'bedrooms': random.randint(1, 5),
            'bathrooms': random.randint(1, 4),
            'year_built': random.randint(1990, 2023),
            'description': fake.text(max_nb_chars=200),
            'created_at': fake.date_time_this_year().isoformat()
        }
        properties.append(property)
    return properties

def generate_user_preferences() -> Dict:
    return {
        'target_price': round(random.uniform(200000, 800000), 2),
        'preferred_location': {
            'latitude': float(fake.latitude()),
            'longitude': float(fake.longitude())
        },
        'preferred_amenities': random.sample(
            ['pool', 'garden', 'gym', 'parking', 'security'], 
            random.randint(2, 4)
        ),
        'preferred_type': random.choice(['apartment', 'house', 'villa'])
    }

def generate_interaction_history(property_ids: List[str]) -> Dict:
    interactions = {
        'view_counts': {},
        'favorites': [],
        'clicks': {}
    }
    
    for prop_id in property_ids:
        if random.random() > 0.3:
            interactions['view_counts'][prop_id] = random.randint(1, 20)
        
        if random.random() > 0.7:
            interactions['favorites'].append(prop_id)
        
        if random.random() > 0.5:
            click_dates = [
                (datetime.now() - timedelta(days=random.randint(0, 14))).isoformat()
                for _ in range(random.randint(1, 8))
            ]
            interactions['clicks'][prop_id] = click_dates
    
    return interactions

def generate_market_trends(locations: List[str]) -> Dict:
    return {
        location: {
            'demand': round(random.uniform(0.1, 1.0), 2),
            'price_appreciation': round(random.uniform(-0.05, 0.15), 2),
            'development_score': round(random.uniform(0.1, 1.0), 2),
            'price_growth': round(random.uniform(-0.02, 0.08), 2)
        }
        for location in locations
    }

def save_mock_data():
    properties = generate_mock_properties()
    locations = list(set(p['location'] for p in properties))
    property_ids = [p['id'] for p in properties]
    
    mock_data = {
        'properties': properties,
        'user_preferences': generate_user_preferences(),
        'interaction_history': generate_interaction_history(property_ids),
        'market_trends': generate_market_trends(locations)
    }
    
    with open('mock_data.json', 'w') as f:
        json.dump(mock_data, f, indent=2)

if __name__ == '__main__':
    save_mock_data()