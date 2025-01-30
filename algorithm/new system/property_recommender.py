import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.metrics.pairwise import cosine_similarity
from geopy.distance import geodesic

class PropertyRecommender:
    def __init__(self, model_trainer=None):
        self.scaler = StandardScaler()
        self.model_trainer = model_trainer
        
    def update_recommendations_with_model(self, properties_df):
        if self.model_trainer and self.model_trainer.is_trained:
            X, _ = self.model_trainer.prepare_training_data(properties_df)
            predicted_scores = self.model_trainer.model.predict(X)
            properties_df['predicted_interaction_score'] = predicted_scores
            return properties_df
        return properties_df
        
    def prepare_features(self, properties_df):
        # Feature weights (location gets higher weight)
        weights = {
            'location_score': 0.3,  # 30% weight for location
            'price': 0.15,
            'view_count': 0.1,
            'interaction_score': 0.1,
            'favorite_count': 0.1,
            'rating': 0.1,
            'bathrooms': 0.05,
            'bedrooms': 0.05,
            'property_type_score': 0.05
        }
        
        # Create location score based on latitude and longitude
        def calculate_location_score(row, user_lat, user_lon):
            property_coords = (row['latitude'], row['longitude'])
            user_coords = (user_lat, user_lon)
            distance = geodesic(property_coords, user_coords).kilometers
            return 1 / (1 + distance)  # Inverse distance for closer properties to score higher
            
        # One-hot encode categorical features
        property_type_dummies = pd.get_dummies(properties_df['category'], prefix='type')
        
        # Normalize numerical features
        numerical_features = ['price', 'view_count', 'interaction_score', 
                            'favorite_count', 'rating', 'bathrooms', 'bedrooms']
        
        scaled_features = self.scaler.fit_transform(properties_df[numerical_features])
        
        # Combine all features with their weights
        weighted_features = np.column_stack([
            scaled_features * weights['price'],
            property_type_dummies.values * weights['property_type_score'],
            properties_df['location_score'].values.reshape(-1, 1) * weights['location_score']
        ])
        
        return weighted_features

def get_recommendations(self, user_id, properties_df, user_lat, user_lon, n_recommendations=5):
        properties_df = self.update_recommendations_with_model(properties_df)
        # Check if location and user data is available
        has_location = user_lat != 0.0 and user_lon != 0.0
        has_user = user_id != ""
        
        if not has_location:
            # Remove location weighting when location unavailable
            weights = {
                'price': 0.25,
                'view_count': 0.2,
                'interaction_score': 0.15,
                'favorite_count': 0.15,
                'rating': 0.15,
                'property_type_score': 0.1
            }
        else:
            # Use original weights with location
            weights = {
                'location_score': 0.3,
                'price': 0.15,
                'view_count': 0.1,
                'interaction_score': 0.1,
                'favorite_count': 0.1,
                'rating': 0.1,
                'property_type_score': 0.15
            }
            properties_df['location_score'] = properties_df.apply(
                lambda x: self.calculate_location_score(x, user_lat, user_lon), axis=1
            )

        feature_matrix = self.prepare_features(properties_df, weights)
        
        if not has_user:
            # Return trending properties based on views and ratings
            return self.get_trending_properties(properties_df, n_recommendations)
            
        # Continue with personalized recommendations for logged in users
        similarity_matrix = cosine_similarity(feature_matrix)
        user_interactions = properties_df[properties_df['viewed_by'].str.contains(user_id)]
        
        if len(user_interactions) == 0:
            return self.get_trending_properties(properties_df, n_recommendations)
            
        user_property_indices = user_interactions.index
        similarity_scores = similarity_matrix[user_property_indices].mean(axis=0)
        recommended_indices = np.argsort(similarity_scores)[-n_recommendations:][::-1]
        
        return properties_df.iloc[recommended_indices]

    def get_trending_properties(self, properties_df, n_recommendations):
        properties_df['trending_score'] = (
            properties_df['view_count'] * 0.4 +
            properties_df['favorite_count'] * 0.3 +
            properties_df['rating'] * 0.3
        )
        return properties_df.nlargest(n_recommendations, 'trending_score')

    def get_popular_nearby_properties(self, properties_df, user_lat, user_lon, n_recommendations):
        properties_df['location_score'] = properties_df.apply(
            lambda x: self.calculate_location_score(x, user_lat, user_lon), axis=1
        )
        
        # Combine popularity metrics with location score
        properties_df['popularity_score'] = (
            properties_df['view_count'] * 0.3 +
            properties_df['favorite_count'] * 0.3 +
            properties_df['rating'] * 0.2 +
            properties_df['location_score'] * 0.2
        )
        
        return properties_df.nlargest(n_recommendations, 'popularity_score')
