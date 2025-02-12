package com.example.touristGuide_app.Activities;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.bumptech.glide.Glide;
import com.example.touristGuide_app.Domains.OneEventDomain;
import com.example.touristGuide_app.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class DetailActivity extends AppCompatActivity {
    private TextView nameTxt, organizerTxt, contactTxt, aboutTxt, priceTxt, maxParticipantsTxt, currentParticipantsTxt;
    private TextView startDateTxt, endDateTxt;
    private String startDate, endDate;
    String eventId;
    int calendarIdReq, userIdReq;
    private String serverIp;
    private OneEventDomain item;
    private ImageView thumbnailEventImg, backBtn, favoritesIcon, categoryEventImg;
    private Button btnBookNow;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        eventId = getIntent().getStringExtra("eventId");
        serverIp = getString(R.string.ip);

        calendarIdReq = getIntent().getIntExtra("calendarIdReq", 0);
        System.out.println("calendarIdReqqqqqqqqqqq detail activity "+ calendarIdReq);

        userIdReq = getIntent().getIntExtra("userIdReq", 0);
        System.out.println("userIdReqqqqqqqqqqq detail activity "+ userIdReq);

        setContentView(R.layout.activity_detail);
        initView();

        fetchEventDetails(eventId);
        setVariable();
    }
    private void initView() {
        nameTxt = findViewById(R.id.nameTxt);
        organizerTxt = findViewById(R.id.organizerTxt);
        categoryEventImg = findViewById(R.id.categoryEventImg);
        contactTxt = findViewById(R.id.contactTxt);

        startDateTxt = findViewById(R.id.startDateTxt);
        endDateTxt = findViewById(R.id.endDateTxt);

        aboutTxt = findViewById(R.id.aboutTxt);
        priceTxt = findViewById(R.id.priceTxt);

        maxParticipantsTxt = findViewById(R.id.maxParticipantsTxt);
        currentParticipantsTxt = findViewById(R.id.currentParticipantsTxt);

        favoritesIcon = findViewById(R.id.favoritesIcon);
        thumbnailEventImg = findViewById(R.id.thumbnailEventImg);
        backBtn = findViewById(R.id.backBtn);
        btnBookNow = findViewById(R.id.btnBookNow);
        // Inicializa o dateFormat
    }
    private void setVariable() {
        item = (OneEventDomain) getIntent().getSerializableExtra("object");
        backBtn.setOnClickListener(v -> finish());

        // Set the favorite icon click listener


        btnBookNow.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Toggle favorite status (this example just sets it to true, you may want to toggle based on current status)
                updateFavoriteStatus(true);
                // Criar um AlertDialog.Builder
                AlertDialog.Builder builder = new AlertDialog.Builder(DetailActivity.this);
                // Definir título e mensagem do popup
                builder.setTitle("Booking Successful")
                        .setMessage("Your booking has been successfully made.")
                        // Adicionar botão de OK e definir seu comportamento
                        .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                try {
                                    // Start the CalendarEmpty activity and pass event details as extras
                                    Intent intent = new Intent(DetailActivity.this, CalendarEmpty.class);
                                    intent.putExtra("startDate", startDate);
                                    intent.putExtra("endDate", endDate);
                                    intent.putExtra("userIdReq", userIdReq);
                                    intent.putExtra("calendarIdReq", calendarIdReq);
                                    intent.putExtra("fromDetailActivity", true);

                                    Log.d("DetailActivity", "Starting CalendarEmpty activity");
                                    startActivity(intent);
                                } catch (Exception e) {
                                    Log.e("DetailActivity", "Error starting CalendarEmpty activity", e);
                                }
                                dialog.dismiss();
                            }
                        });
                // Criar e exibir o AlertDialog
                AlertDialog alertDialog = builder.create();
                alertDialog.show();
            }
        });
    }
    private void fetchEventDetails(String eventId) {
        String url = "http://grupo4-egs-deti.ua.pt/e1/events/" + eventId;
        String apiKey = "93489d58-e2cf-4e11-b3ac-74381fee38ac";
        RequestQueue queue = Volley.newRequestQueue(this);
        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest
                (Request.Method.GET, url, null, new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            // Parse the JSON response and update the UI
                            String name = response.getString("name");
                            String organizer = response.getString("organizer");
                            String contact = response.getString("contact");
                            String about = response.getString("about");
                            double price = response.getDouble("price");
                            String currency = response.getString("currency");
                            int maxParticipants = response.getInt("maxparticipants");
                            int currentParticipants = response.getInt("currentparticipants");

                            startDate = response.getString("startdate");
                            endDate = response.getString("enddate");
                            String category = response.getJSONObject("pointofinterest").getString("category").toLowerCase();


                            String thumbnail = response.getJSONObject("pointofinterest").getString("thumbnail");

                            nameTxt.setText(name);
                            organizerTxt.setText(organizer);
                            contactTxt.setText(contact);
                            aboutTxt.setText(about);
                            priceTxt.setText(currency + " " + price);
                            maxParticipantsTxt.setText(String.valueOf(maxParticipants));
                            currentParticipantsTxt.setText(String.valueOf(currentParticipants));
                            startDateTxt.setText(startDate);
                            endDateTxt.setText(endDate);

                            Glide.with(DetailActivity.this).load(thumbnail).into(thumbnailEventImg);
                        } catch (JSONException e) {
                            e.printStackTrace();
                            Toast.makeText(DetailActivity.this, "Failed to parse event details", Toast.LENGTH_SHORT).show();
                        }
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        handleErrorResponse(error);
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
        queue.add(jsonObjectRequest);
    }
    private void updateFavoriteStatus(boolean isFavorite) {
        String url = "http://grupo4-egs-deti.ua.pt/e1/events/" + eventId + "/favorite";
        String apiKey = "93489d58-e2cf-4e11-b3ac-74381fee38ac";

        Log.d("DetailActivity", "calendarIdReq: " + calendarIdReq);
        Log.d("DetailActivity", "userIdReq: " + userIdReq);

        RequestQueue queue = Volley.newRequestQueue(this);

        JSONObject requestBody = new JSONObject();
        try {
            requestBody.put("userid", String.valueOf(userIdReq));
            requestBody.put("calendarid", String.valueOf(calendarIdReq));
            requestBody.put("favoritestatus", isFavorite);
        } catch (JSONException e) {
            e.printStackTrace();
            Toast.makeText(this, "Failed to create JSON request body", Toast.LENGTH_SHORT).show();
            Log.e("DetailActivity", "Failed to create JSON request body");
            return;
        }

        Log.d("DetailActivity", "Request URL: " + url);
        Log.d("DetailActivity", "Request Body: " + requestBody.toString());

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(
                Request.Method.PATCH, url, requestBody,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d("DetailActivity", "Response received: " + response.toString());
                        Toast.makeText(DetailActivity.this, "Favorite status updated successfully", Toast.LENGTH_SHORT).show();
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.e("DetailActivity", "Error: " + error.toString());
                        handleErrorResponse(error);
                    }
                }) {
            @Override
            public Map<String, String> getHeaders() {
                Map<String, String> headers = new HashMap<>();
                headers.put("accept", "application/json");
                headers.put("SERVICE-API-KEY", apiKey);
                headers.put("Content-Type", "application/json");
                return headers;
            }
        };

        queue.add(jsonObjectRequest);
    }
    private void handleErrorResponse(VolleyError error) {
        if (error.networkResponse != null) {
            int statusCode = error.networkResponse.statusCode;
            String errorMessage = new String(error.networkResponse.data);
            Log.e("DetailActivity", "Status Code: " + statusCode);
            Log.e("DetailActivity", "Error response: " + errorMessage);

            try {
                JSONObject errorJson = new JSONObject(errorMessage);
                if (errorJson.has("error")) {
                    JSONObject errorObject = errorJson.getJSONObject("error");
                    String message = errorObject.getString("message");

                    switch (statusCode) {
                        case 400:
                            Toast.makeText(DetailActivity.this, "Erro 400: Bad Request - " + message, Toast.LENGTH_SHORT).show();
                            break;
                        case 401:
                            Toast.makeText(DetailActivity.this, "Erro 401: Não autorizado - " + message, Toast.LENGTH_SHORT).show();
                            break;
                        case 404:
                            Toast.makeText(DetailActivity.this, "Erro 404: Recurso não encontrado - " + message, Toast.LENGTH_SHORT).show();
                            break;
                        case 500:
                            Toast.makeText(DetailActivity.this, "Erro 500: Erro interno do servidor - " + message, Toast.LENGTH_SHORT).show();
                            break;
                        case 502:
                            Toast.makeText(DetailActivity.this, "Erro 502: Bad Gateway - " + message, Toast.LENGTH_SHORT).show();
                            break;
                        default:
                            Toast.makeText(DetailActivity.this, "Erro " + statusCode + ": " + message, Toast.LENGTH_SHORT).show();
                            break;
                    }
                } else {
                    Toast.makeText(DetailActivity.this, "Erro JSON inesperado: " + errorMessage, Toast.LENGTH_SHORT).show();
                }
            } catch (JSONException e) {
                e.printStackTrace();
                Toast.makeText(DetailActivity.this, "Erro ao processar resposta de erro JSON", Toast.LENGTH_SHORT).show();
            }
        } else {
            Log.e("DetailActivity", "Network error occurred", error);
            Toast.makeText(DetailActivity.this, "SUCCESS.", Toast.LENGTH_SHORT).show();
        }
    }
}