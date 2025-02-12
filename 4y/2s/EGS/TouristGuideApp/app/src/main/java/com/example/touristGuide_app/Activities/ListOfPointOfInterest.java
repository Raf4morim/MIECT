package com.example.touristGuide_app.Activities;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.android.volley.Request;
import com.android.volley.toolbox.JsonObjectRequest;
import com.example.touristGuide_app.Adapters.CategoryAdapter;
import com.example.touristGuide_app.Adapters.PointOfInterestAdapter;
import com.example.touristGuide_app.Domains.CategoryDomain;
import com.example.touristGuide_app.Domains.PointOfInterestDomain;
import com.example.touristGuide_app.R;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.ArrayList;

import android.os.AsyncTask;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

public class ListOfPointOfInterest extends AppCompatActivity implements OnLocationSelectedListener, OnFilterAppliedListener, CategoryAdapter.OnCategorySelectedListener {
    private RecyclerView.Adapter adapterCategory;
    private RecyclerView recyclerViewPoi;
    private PointOfInterestAdapter adapterPoi;
    private RecyclerView recyclerViewCategory;
    private EditText searchBarMain;
    String serverIp;
    private int userIdReq = 0, calendarIdReq = 0;
    private String selectedCategory = null; // Categoria selecionada
    private double selectedLatitude = 0, selectedLongitude = 0;
    private float selectedRadius = 0;
    private String selectedLocationName = null;
    private String id_poi;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.list_of_pois);
        serverIp = getString(R.string.ip);
        userIdReq = getIntent().getIntExtra("userIdReq",0);
        calendarIdReq = getIntent().getIntExtra("calendarIdReq",0);
        searchBarMain = findViewById(R.id.search_bar_main);
        searchBarMain.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                // Não é necessário implementar
            }
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String searchText = s.toString();
                fetchPOIsFromGraphQL(selectedCategory, selectedLatitude, selectedLongitude, selectedRadius, searchText);
            }
            @Override
            public void afterTextChanged(Editable s) {
                // Não é necessário implementar
            }
        });
        initRecyclerView();
    }
    private void initRecyclerView(){
        //////////////FILTROS
        ConstraintLayout filterLayout = findViewById(R.id.btnFiltros);
        filterLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onFilterButtonClick(v);
            }
        });
        //////////////////////////// POIS
        fetchPOIsFromGraphQL(null, 0, 0, 0, null);
        // Lista de categorias
        ArrayList<CategoryDomain> catsList = new ArrayList<>();
        catsList.add(new CategoryDomain("Nature"));
        catsList.add(new CategoryDomain("Food"));
        catsList.add(new CategoryDomain("Culture"));
        catsList.add(new CategoryDomain("Shopping"));
        catsList.add(new CategoryDomain("Landmarks"));

        // Configuração do RecyclerView e do adapter
        recyclerViewCategory = findViewById(R.id.viewCat);
        recyclerViewCategory.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        adapterCategory = new CategoryAdapter(catsList, this);
        recyclerViewCategory.setAdapter(adapterCategory);

        ////////////////////////////changeAccountIcon Menu Icon
        // Change Account Icon (Floating Action Button)
        FloatingActionButton changeAccountIcon = findViewById(R.id.changeAccountIcon);
        changeAccountIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ListOfPointOfInterest.this, Login.class);
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
                Intent intent = new Intent(ListOfPointOfInterest.this, ListOfPointOfInterest.class);
                startActivity(intent);
            }
        });

        // My Calendar Icon
        LinearLayout myCalendarLayout = findViewById(R.id.myCalendar);
        myCalendarLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ListOfPointOfInterest.this, CalendarEmpty.class);
                intent.putExtra("fromDetailActivity", false);
                intent.putExtra("userIdReq", userIdReq);
                intent.putExtra("calendarIdReq", calendarIdReq);
                startActivity(intent);
            }
        });
    }
    public void onFilterButtonClick(View view) {
        FilterPopup filterPopup = new FilterPopup();
        // Defina este MainActivity como o listener para receber as coordenadas selecionadas
        filterPopup.setOnFilterAppliedListener(this);
        filterPopup.setOnLocationSelectedListener(this);
        filterPopup.show(getSupportFragmentManager(), "filter_popup");
    }
    @Override
    public void onFilterApplied(double latitude, double longitude, String locationName, float radius, String category) {
        // Aqui você recebe os dados dos filtros aplicados
        selectedLatitude = latitude;
        selectedLongitude = longitude;
        selectedRadius = radius;
        selectedCategory = category;
        selectedLocationName = locationName;
        System.out.println("Latitude: " + latitude + ", Longitude: " + longitude + ", Location Name: " + locationName + ", Radius: " + radius + ", Category: " + category);
        Toast.makeText(this, "Filtros aplicados!", Toast.LENGTH_SHORT).show();
        // Atualize os POIs com base nos filtros aplicados
        fetchPOIsFromGraphQL(selectedCategory, selectedLatitude, selectedLongitude, selectedRadius, selectedLocationName);
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
    private void initRecyclerPOIView(ArrayList<PointOfInterestDomain> pois) {
        // AQUI É QUE MOSTRA CADA UM QUANDO CLICO AQUI ABRE UMA NOVA PAGINA
        // Configura o RecyclerView e o adaptador após receber os POIs
        recyclerViewPoi = findViewById(R.id.recyclerViewPoi);
        recyclerViewPoi.setLayoutManager(new LinearLayoutManager(this));
        adapterPoi = new PointOfInterestAdapter(pois, userIdReq, calendarIdReq, id_poi);
        recyclerViewPoi.setAdapter(adapterPoi);
        // Aqui você pode adicionar prints para verificar se os POIs foram recebidos corretamente
        Log.d("ListOfPointOfInterest", "POIs recebidos: " + pois.size());
    }
    // Manipular seleção de categoria
    @Override
    public void onCategorySelected(String category) {
        selectedCategory = category;
        fetchPOIsFromGraphQL(selectedCategory, selectedLatitude, selectedLongitude, selectedRadius, selectedLocationName);
    }
    @Override
    public void onCategoryDeselected(String category) {
        if (selectedCategory != null && selectedCategory.equals(category)) {
            selectedCategory = null;
            fetchPOIsFromGraphQL(selectedCategory, selectedLatitude, selectedLongitude, selectedRadius, selectedLocationName);
        }
    }
    private void fetchPOIsFromGraphQL(@Nullable String category, double latitude, double longitude, float radius, @Nullable String locationName) {
        JSONObject jsonBody = new JSONObject();
        try {
            String query = "query findPOIs { searchPointsOfInterest(apiKey: \"Tigas:4712b0a1d771938c04e5cba078b0a889\", searchInput: {";
            if (latitude != 0 && longitude != 0 && radius != 0) {
                query += " location: { type: \"Point\", coordinates: [" + longitude + ", " + latitude + "] }, radius: " + radius + ",";
            }
            if (category != null) {
                query += " category: \"" + category + "\",";
            }
            if (locationName != null && !locationName.isEmpty()) {
                query += " locationName: \"" + locationName + "\",";
            }
            // Remove a última vírgula se necessário
            if (query.endsWith(",")) {
                query = query.substring(0, query.length() - 1);
            }
            query += " }) { _id name location { coordinates } locationName street postcode description category thumbnail event_ids } }";
            jsonBody.put("query", query);
        } catch (JSONException e) {
            e.printStackTrace();
            Toast.makeText(ListOfPointOfInterest.this, "Erro ao enviar o request JSON", Toast.LENGTH_SHORT).show();
            return;
        }
        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, "http://"+serverIp+"/graphql", jsonBody,
                response -> {
                    try {
                        if (response.has("errors")) {
                            JSONArray errors = response.getJSONArray("errors");
                            if (errors.length() > 0) {
                                String errorMessage = errors.getJSONObject(0).getString("message");
                                runOnUiThread(() -> showNoResultsPopup(errorMessage));
                                return;
                            }
                        }
                        JSONArray poiArray = response.getJSONObject("data").getJSONArray("searchPointsOfInterest");
                        ArrayList<PointOfInterestDomain> pois = new ArrayList<>();
                        for (int i = 0; i < poiArray.length(); i++) {
                            JSONObject poiObject = poiArray.getJSONObject(i);
                            id_poi = poiObject.getString("_id");
                            System.out.println("id_poie: "+id_poi);
                            String name = poiObject.getString("name");
                            String locationNameResponse = poiObject.getString("locationName");
                            JSONObject location = poiObject.getJSONObject("location");
                            double latitudeResponse = location.getJSONArray("coordinates").getDouble(1);
                            double longitudeResponse = location.getJSONArray("coordinates").getDouble(0);
                            String street = poiObject.optString("street", null);
                            String postcode = poiObject.optString("postcode", null);
                            String description = poiObject.getString("description");
                            String categoryReceived = poiObject.getString("category");
                            String thumbnail = poiObject.getString("thumbnail");
                            pois.add(new PointOfInterestDomain(id_poi, name, locationNameResponse, latitudeResponse, longitudeResponse, street, postcode, description, categoryReceived, thumbnail));
                        }
                        runOnUiThread(() -> initRecyclerPOIView(pois));
                    } catch (JSONException e) {
                        e.printStackTrace();
                        Toast.makeText(ListOfPointOfInterest.this, "Erro ao processar resposta JSON", Toast.LENGTH_SHORT).show();
                    }
                }, error -> {
            Toast.makeText(ListOfPointOfInterest.this, "Erro na solicitação: " + error.getMessage(), Toast.LENGTH_SHORT).show();
        });
        RequestQueueSingleton.getInstance(this).addToRequestQueue(jsonObjectRequest);
    }
    private void showNoResultsPopup(String message) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Sem Resultados");
        builder.setMessage(message);
        builder.setPositiveButton("OK", null);
        builder.show();
    }
}