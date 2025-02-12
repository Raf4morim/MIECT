package com.example.touristGuide_app.Activities;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.android.volley.Request;
import com.android.volley.toolbox.JsonArrayRequest;
import com.example.touristGuide_app.Adapters.ListEventsAdapter;
import com.example.touristGuide_app.Domains.ListEventsDomain;
import com.example.touristGuide_app.Domains.PointOfInterestDomain;
import com.example.touristGuide_app.R;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;


public class ListOfEvents extends AppCompatActivity implements OnLocationSelectedListener {
    private RecyclerView.Adapter adapterPopular;
    private RecyclerView recyclerViewPopular;
    private String serverIp;
    private int userIdReq;
    private int calendarIdReq;
    private String id_poi;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.list_of_events);

        Intent intent = getIntent();
        userIdReq = intent.getIntExtra("userIdReq", 0);
        calendarIdReq = intent.getIntExtra("calendarIdReq", 0);
        id_poi = intent.getStringExtra("poiId");
        System.out.println("userIdAndCalendarId "+ userIdReq +" " + calendarIdReq);

        serverIp = getString(R.string.ip);

        System.out.println("userIdReq: " + userIdReq + " calendarIdReq: " + calendarIdReq);
        initRecyclerView();
        Log.d("API_RESPONSE", "passou aqui3: " );
    }
    private void initRecyclerView() {
        //////////////FILTROS
        ConstraintLayout filterLayout = findViewById(R.id.btnFiltros);
        filterLayout.setOnClickListener(this::onFilterButtonClick);
        ////////////////////////////changeAccountIcon Menu Icon
        // Change Account Icon (Floating Action Button)
        FloatingActionButton changeAccountIcon = findViewById(R.id.changeAccountIcon);
        changeAccountIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ListOfEvents.this, Login.class);
                startActivity(intent);
            }
        });

        // Home Icon
        LinearLayout homeIcon = findViewById(R.id.homeIcon);
        homeIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Navigate to home activity or handle home icon click
                // Assuming you have a MainActivity for home
                Intent intent = new Intent(ListOfEvents.this, ListOfPointOfInterest.class);
                startActivity(intent);
            }
        });

        // My Calendar Icon
        LinearLayout myCalendarLayout = findViewById(R.id.myCalendar);
        myCalendarLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ListOfEvents.this, CalendarEmpty.class);
                intent.putExtra("fromDetailActivity", false);
                intent.putExtra("userIdReq", userIdReq);
                intent.putExtra("calendarIdReq", calendarIdReq);
                startActivity(intent);
            }
        });

        //////////////////////////// EVENTs
        fetchEventsFromAPI();
    }

    public void onFilterButtonClick(View view) {
        FilterPopup filterPopup = new FilterPopup();
        // Defina este MainActivity como o listener para receber as coordenadas selecionadas
        // filterPopup.setOnLocationSelectedListener(this);
        filterPopup.show(getSupportFragmentManager(), "filter_popup");
    }
    @Override
    public void onLocationSelected(double latitude, double longitude) {
        System.out.println("Main onLocationSelected activity Latitude: " + latitude + ", Longitude: " + longitude);
        Toast.makeText(this, "Retornou latitude: "+latitude+" e longitude: "+longitude, Toast.LENGTH_SHORT).show();
        // Obtém uma referência para o FilterPopup atualmente exibido
        FilterPopup filterPopup = (FilterPopup) getSupportFragmentManager().findFragmentByTag("filter_popup");
        // Verifica se o popup está sendo exibido antes de atualizar as coordenadas
        if (filterPopup != null) {
            filterPopup.updateLocation(latitude, longitude);
        }
    }
    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1 && resultCode == RESULT_OK && data != null) {
            double latitude = data.getDoubleExtra("latitude", 0);
            double longitude = data.getDoubleExtra("longitude", 0);
            System.out.println("Main activity onActivityResult Latitude: " + latitude + ", Longitude: " + longitude);
            // Obtém uma referência para o FilterPopup atualmente exibido
            FilterPopup filterPopup = (FilterPopup) getSupportFragmentManager().findFragmentByTag("filter_popup");
            // Verifica se o popup está sendo exibido antes de atualizar as coordenadas
            if (filterPopup != null) {
                filterPopup.updateLocation(latitude, longitude);
            }
        }
    }
    private void initRecyclerEVENTsView(ArrayList<ListEventsDomain> events) {
        recyclerViewPopular = findViewById(R.id.viewEvent);
        recyclerViewPopular.setLayoutManager(new LinearLayoutManager(this));
        adapterPopular = new ListEventsAdapter(this, events);
        recyclerViewPopular.setAdapter(adapterPopular);
        Log.d("API_RESPONSE", "RecyclerView initialized with events: " + events.size());
    }
    private void fetchEventsFromAPI() {
        String url = "http://" + serverIp + "/e1/events?limit=25&offset=0&calendarid=" + calendarIdReq;
        System.out.println("poiiiiiiiiiiiiiiii "+ id_poi);
        if (id_poi != null) {
            url += "&pointofinterestid=" + id_poi;
        }


        System.out.println("urliiiiii: " + url);
        String apiKey = "93489d58-e2cf-4e11-b3ac-74381fee38ac";

        JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(Request.Method.GET, url, null,
                response -> {
                    try {
                        JSONArray eventsArray = response;
                        ArrayList<ListEventsDomain> events = new ArrayList<>();
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());

                        for (int i = 0; i < eventsArray.length(); i++) {
                            JSONObject eventObject = eventsArray.getJSONObject(i);

                            // Extract and parse the data from JSON
                            String id = eventObject.getString("_id");
                            String name = eventObject.getString("name");
                            String organizer = eventObject.getString("organizer");
                            String category = eventObject.getString("category");
                            String contact = eventObject.getString("contact");

                            Date startDate = null;
                            Date endDate = null;
                            try {
                                startDate = dateFormat.parse(eventObject.getString("startdate"));
                                endDate = dateFormat.parse(eventObject.getString("enddate"));
                            } catch (ParseException e) {
                                e.printStackTrace();
                                Log.e("DATE_FORMAT_ERROR", "Erro ao analisar a data", e);
                                Toast.makeText(ListOfEvents.this, "Erro ao analisar a data", Toast.LENGTH_SHORT).show();
                            }

                            String about = eventObject.getString("about");
                            double price = eventObject.getDouble("price");
                            String currency = eventObject.getString("currency");
                            int maxParticipants = eventObject.getInt("maxparticipants");
                            int currentParticipants = eventObject.getInt("currentparticipants");
                            int favorites = eventObject.getInt("favorites");
                            String poiId = eventObject.getString("pointofinterestid");

                            JSONObject poiObject = eventObject.getJSONObject("pointofinterest");
                            PointOfInterestDomain pointOfInterest = new PointOfInterestDomain(
                                    poiObject.optString("_id", ""),
                                    poiObject.getString("name"),
                                    poiObject.getString("location"),
                                    poiObject.getDouble("latitude"),
                                    poiObject.getDouble("longitude"),
                                    poiObject.optString("street", ""),
                                    poiObject.optString("postcode", ""),
                                    poiObject.getString("description"),
                                    poiObject.getString("category"),
                                    poiObject.getString("thumbnail")
                            );

                            events.add(new ListEventsDomain(id, name, organizer, category, contact, startDate, endDate, about, price, currency, maxParticipants, currentParticipants, favorites, poiId, pointOfInterest, "pic1", userIdReq, calendarIdReq));
                        }

                        runOnUiThread(() -> initRecyclerEVENTsView(events));
                    } catch (JSONException e) {
                        e.printStackTrace();
                        Log.e("API_ERROR", "Erro ao processar resposta JSON: " + e.getMessage());
                        Toast.makeText(ListOfEvents.this, "Erro ao processar resposta JSON", Toast.LENGTH_SHORT).show();
                    }
                },
                error -> {
                    // Handle network errors
                    if (error.networkResponse != null) {
                        int statusCode = error.networkResponse.statusCode;
                        String errorMessage = new String(error.networkResponse.data);
                        Log.e("API_ERROR", "Error response: " + errorMessage);

                        try {
                            JSONObject errorJson = new JSONObject(errorMessage);
                            if (errorJson.has("error")) {
                                JSONObject errorObject = errorJson.getJSONObject("error");
                                String errorCode = errorObject.getString("code");
                                String message = errorObject.getString("message");

                                switch (statusCode) {
                                    case 401:
                                        Toast.makeText(ListOfEvents.this, "Erro 401: Não autorizado - " + message, Toast.LENGTH_SHORT).show();
                                        break;
                                    case 404:
                                        Toast.makeText(ListOfEvents.this, "Erro 404: Recurso não encontrado - " + message, Toast.LENGTH_SHORT).show();
                                        break;
                                    default:
                                        Toast.makeText(ListOfEvents.this, "Erro " + statusCode + ": " + message, Toast.LENGTH_SHORT).show();
                                        break;
                                }
                            } else {
                                Toast.makeText(ListOfEvents.this, "Erro JSON inesperado: " + errorMessage, Toast.LENGTH_SHORT).show();
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                            Toast.makeText(ListOfEvents.this, "Erro ao processar resposta de erro JSON", Toast.LENGTH_SHORT).show();
                        }
                    } else {
                        Log.e("API_ERROR", "Network error occurred");
                        Toast.makeText(ListOfEvents.this, "Erro de rede ao carregar os eventos. Verifique sua conexão com a Internet e tente novamente.", Toast.LENGTH_SHORT).show();
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

        RequestQueueSingleton.getInstance(this).addToRequestQueue(jsonArrayRequest);
    }

}