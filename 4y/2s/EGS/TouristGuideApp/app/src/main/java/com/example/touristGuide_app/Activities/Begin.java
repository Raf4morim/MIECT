package com.example.touristGuide_app.Activities;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import com.example.touristGuide_app.R;

public class Begin extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.begin);

        ConstraintLayout introBtn = findViewById(R.id.introBtn);
        introBtn.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick( View v){
                startActivity(new Intent(Begin.this, Login.class));

            }
        });

    }
}
