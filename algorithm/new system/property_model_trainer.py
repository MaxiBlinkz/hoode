from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
import joblib

class PropertyModelTrainer:
    def __init__(self):
        self.model = RandomForestRegressor(n_estimators=100)
        self.is_trained = False
        
    def prepare_training_data(self, properties_df):
        features = ['price', 'bedrooms', 'bathrooms', 'view_count', 
                   'favorite_count', 'rating', 'interaction_score']
        X = properties_df[features]
        y = properties_df['interaction_score']  # Target variable
        return X, y
        
    def train_model(self, properties_df):
        X, y = self.prepare_training_data(properties_df)
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
        
        self.model.fit(X_train, y_train)
        self.is_trained = True
        
        score = self.model.score(X_test, y_test)
        return score
        
    def update_model(self, new_properties_df):
        if not self.is_trained:
            return self.train_model(new_properties_df)
            
        X_new, y_new = self.prepare_training_data(new_properties_df)
        self.model.fit(X_new, y_new)
        return self.model.score(X_new, y_new)
        
    def save_model(self, filepath):
        joblib.dump(self.model, filepath)
        
    def load_model(self, filepath):
        self.model = joblib.load(filepath)
        self.is_trained = True
