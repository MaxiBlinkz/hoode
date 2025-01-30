import numpy as np
import pandas as pd
from faker import Faker
import random

class PropertyDataGenerator:
    def __init__(self):
        self.fake = Faker()
        
    def generate_sample_properties(self, num_samples=1000):
        properties = []
        categories = ['Apartment', 'House', 'Villa', 'Condo', 'Townhouse']
        
        for _ in range(num_samples):
            property_data = {
                'property_id': self.fake.uuid4(),
                'category': random.choice(categories),
                'price': random.uniform(100000, 1000000),
                'bedrooms': random.randint(1, 6),
                'bathrooms': random.randint(1, 4),
                'latitude': random.uniform(-90, 90),
                'longitude': random.uniform(-180, 180),
                'view_count': random.randint(0, 10000),
                'favorite_count': random.randint(0, 1000),
                'rating': random.uniform(3.0, 5.0),
                'interaction_score': random.uniform(0, 100),
                'viewed_by': ','.join([self.fake.uuid4() for _ in range(random.randint(0, 20))])
            }
            properties.append(property_data)
            
        return pd.DataFrame(properties)
