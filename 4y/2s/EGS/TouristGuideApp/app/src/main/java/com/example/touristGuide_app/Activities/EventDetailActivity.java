package com.example.touristGuide_app.Activities;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import com.example.touristGuide_app.R;
import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class EventDetailActivity extends AppCompatActivity {
    private String eventId;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_event_detail);



        // Get data from the intent
        Intent intent = getIntent();
        int calendarId = intent.getIntExtra("calendarIdReq", 0);
        int userId = intent.getIntExtra("userIdReq", 0);
        String currentDate = intent.getStringExtra("currentDate");
        eventId = intent.getStringExtra("eventId");
        Log.d("CalendarEmpty", "Received eventId in EventDetailActivity: " + eventId);
        System.out.println("userIdReqqqqqqqqqqqqqqqq: "+userId);

        // Use the data as needed
//        TextView textView = findViewById(R.id.eventNameTextView); // Replace with your actual TextView id
//        textView.setText("Calendar ID: " + calendarId + "\nUser ID: " + userId + "\ncurrent Date: " + currentDate);



        try {
            TextView eventDetailsTextView = findViewById(R.id.eventNameTextView);

            StringBuilder eventDetailsStringBuilder = new StringBuilder();

            eventDetailsTextView.setText(eventDetailsStringBuilder.toString());

            // Attach click listener to the delete button
            Button deleteButton = findViewById(R.id.deleteButton);
            deleteButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Log.d("EventDetailActivity", "Delete button clicked");
                    // Finish this activity
                    finish();
                }
            });

        } catch (JsonSyntaxException e) {
            // If there is an error parsing the JSON, log an error and finish the activity
            e.printStackTrace();
            Log.e("EventDetailActivity", "Error parsing event details JSON");
            Toast.makeText(this, "Error: Unable to parse event details", Toast.LENGTH_SHORT).show();
            finish();
        }
    }
}

