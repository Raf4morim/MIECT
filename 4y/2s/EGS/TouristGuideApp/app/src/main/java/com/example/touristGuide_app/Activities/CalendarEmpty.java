package com.example.touristGuide_app.Activities;
import static com.example.touristGuide_app.Activities.CalendarUtils.daysInMonthArray;
import static com.example.touristGuide_app.Activities.CalendarUtils.monthYearFromDate;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.android.volley.toolbox.JsonArrayRequest;
import com.example.touristGuide_app.Adapters.CalendarAdapter;
import com.example.touristGuide_app.R;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.Volley;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.Map;


public class CalendarEmpty extends AppCompatActivity implements CalendarAdapter.OnItemListener {
    private TextView monthYearText;
    private RecyclerView calendarRecyclerView;
    private String startDateString, endDateString;
    private int userIdReq;
    private int calendarIdReq;
    private LocalDate newLocalDate;
    public static Map<String, List<String>> savingDatesWithIDs = new HashMap<>();
    private RequestQueue requestQueue;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_calendar);
        initWidgets();
        CalendarUtils.selectedDate = LocalDate.now();
        setMonthView();
        // Initialize Volley request queue
        requestQueue = Volley.newRequestQueue(this);
        fetchEventData();
    }

    private void initWidgets() {
        calendarRecyclerView = findViewById(R.id.calendarRecyclerView);
        monthYearText = findViewById(R.id.monthYearTV);
    }

    private void setMonthView() {
        monthYearText.setText(monthYearFromDate(CalendarUtils.selectedDate));
        ArrayList<LocalDate> daysInMonth = daysInMonthArray(CalendarUtils.selectedDate);
        CalendarAdapter calendarAdapter = new CalendarAdapter(daysInMonth, this);
        RecyclerView.LayoutManager layoutManager = new GridLayoutManager(getApplicationContext(), 7);
        calendarRecyclerView.setLayoutManager(layoutManager);
        calendarRecyclerView.setAdapter(calendarAdapter);
    }

    public void previousMonthAction(View view) {
        CalendarUtils.selectedDate = CalendarUtils.selectedDate.minusMonths(1);
        setMonthView();
    }

    public void nextMonthAction(View view) {
        CalendarUtils.selectedDate = CalendarUtils.selectedDate.plusMonths(1);
        setMonthView();
    }

    public void weeklyAction(View view) {
        startActivity(new Intent(this, WeekViewActivity.class));
    }

    @Override
    public void onItemClick(int position, LocalDate date) {
        if (date != null) {
            Log.d("CalendarEmpty", "Date clicked: " + date.toString());

            // Retrieve the list of event IDs for the clicked date
            List<String> eventIds = savingDatesWithIDs.get(date.toString());

            // Start ListOfEventsPerDay and pass the necessary data
            Intent intent = new Intent(this, ListOfEvents_per_day.class);
            intent.putExtra("calendarIdReq", calendarIdReq);
            intent.putExtra("userIdReq", userIdReq);
            intent.putExtra("currentDate", date.toString()); // Pass the clicked date as currentDate
            intent.putStringArrayListExtra("eventIds", new ArrayList<>(eventIds));
            System.out.println("No calendar empty -> userId: " + userIdReq + " calendarId: " + calendarIdReq + " currentDay: " + date.toString());
            startActivity(intent);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        Intent intent = getIntent();

        userIdReq = intent.getIntExtra("userIdReq", 0);
        calendarIdReq = intent.getIntExtra("calendarIdReq", 0);
        Toast.makeText(this, "Recebeu userIdReq: " + userIdReq + "\ncalendarIdReq: " + calendarIdReq + " no CalendarEmpty", Toast.LENGTH_SHORT).show();
        if (intent.getBooleanExtra("fromDetailActivity", false)) {
            if (intent != null) {
                startDateString = intent.getStringExtra("startDate");
                endDateString = intent.getStringExtra("endDate");

                Log.d("CalendarEmpty", "Received startDate: " + startDateString);
                Log.d("CalendarEmpty", "Received endDate: " + endDateString);
                Log.d("CalendarEmpty", "Received userIdReq: " + userIdReq);
                Log.d("CalendarEmpty", "Received calendarIdReq: " + calendarIdReq);
            } else {
                Log.e("CalendarEmpty", "Intent is null");
            }
        }

        fetchEventData();
    }

    private void fetchEventData() {
        String url = "http://grupo4-egs-deti.ua.pt/e1/events?limit=25&offset=0&calendarid=" + calendarIdReq;
        String apiKey = "93489d58-e2cf-4e11-b3ac-74381fee38ac";

        JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(
                Request.Method.GET, url, null,
                new Response.Listener<JSONArray>() {
                    @Override
                    public void onResponse(JSONArray response) {
                        Log.d("CalendarEmpty", "Response received: " + response.toString());
                        parseAndSaveEventData(response);
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(CalendarEmpty.this, "Failed to fetch data from the endpoint", Toast.LENGTH_SHORT).show();
                        Log.e("CalendarEmpty", "Error fetching data: ", error);
                    }
                }) {
            @Override
            public Map<String, String> getHeaders() {
                Map<String, String> headers = new HashMap<>();
                headers.put("accept", "application/json");
                headers.put("SERVICE-API-KEY", apiKey);
                return headers;
            }
        };

        requestQueue.add(jsonArrayRequest);
    }

    private void parseAndSaveEventData(JSONArray jsonArray) {
        try {
            savingDatesWithIDs.clear();
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonData = jsonArray.getJSONObject(i);

                String startDate = jsonData.getString("startdate");
                String endDate = jsonData.getString("enddate");
                String eventId = jsonData.getString("_id");

                // Convert string dates to LocalDate
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDate startLocalDate = LocalDate.parse(startDate, formatter);
                LocalDate endLocalDate = LocalDate.parse(endDate, formatter);

                // Add all dates between start and end dates
                while (!startLocalDate.isAfter(endLocalDate)) {
                    String dateKey = startLocalDate.toString();
                    if (!savingDatesWithIDs.containsKey(dateKey)) {
                        savingDatesWithIDs.put(dateKey, new ArrayList<>());
                    }
                    savingDatesWithIDs.get(dateKey).add(eventId);
                    startLocalDate = startLocalDate.plusDays(1);
                }
            }
            System.out.println("savingDatesWithIDs: " + savingDatesWithIDs);
            setMonthView();
        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(this, "Failed to parse JSON data", Toast.LENGTH_SHORT).show();
        }
    }
}
