package com.example.touristGuide_app.Utils;

import com.google.firebase.Firebase;
import com.google.firebase.auth.FirebaseAuth;

public class ConfigBD {

    private static FirebaseAuth auth;

    public static FirebaseAuth FirebaseAuthentication(){
        if (auth == null) {
            auth = FirebaseAuth.getInstance();
        }
        return auth;
    }
}
