package com.example.touristGuide_app.Activities;


import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.SearchView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.example.touristGuide_app.R;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import android.widget.Toast;

import java.io.IOException;
import java.util.List;

public class PickMap extends AppCompatActivity implements OnMapReadyCallback {
    private GoogleMap myMap;
    private SearchView mapSearchView;
    private OnLocationSelectedListener mListener;
    private double latitude = 0; // Variável para armazenar a latitude selecionada
    private double longitude = 0; // Variável para armazenar a longitude selecionada
    // Interface para definir um listener para receber as coordenadas selecionadas
    public interface OnLocationSelectedListener {
        void onLocationSelected(double latitude, double longitude);
    }
    public void setOnLocationSelectedListener(OnLocationSelectedListener listener) {
        this.mListener = listener;
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.map);
        mapSearchView = findViewById(R.id.mapSearch);
        Button btnChooseCity = findViewById(R.id.btnChooseCity);
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        btnChooseCity.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (latitude != 0 && longitude != 0) {
                    System.out.println("PICKMAP: Latitude: " + latitude + " Longitude: " + longitude);
                    Intent intent = new Intent();
                    intent.putExtra("latitude", latitude);
                    intent.putExtra("longitude", longitude);
                    setResult(RESULT_OK, intent);
                    finish();
                } else {
                    Toast.makeText(PickMap.this, "Não foram passadas coordenadas", Toast.LENGTH_SHORT).show();
                }
            }
        });
        
        mapSearchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                String location = mapSearchView.getQuery().toString();
                List<Address> addressList = null;
                if (location != null) {
                    Geocoder geocoder = new Geocoder(PickMap.this);
                    try {
                        addressList = geocoder.getFromLocationName(location, 1);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    assert addressList != null;
                    Address address = addressList.get(0);
                    LatLng latLng = new LatLng(address.getLatitude(), address.getLongitude());
                    myMap.addMarker(new MarkerOptions().position(latLng).title(location));
                    myMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, 10));
                    // Atualizar as variáveis latitude e longitude
                    latitude = address.getLatitude();
                    longitude = address.getLongitude();
                }
                return false;
            }
            @Override
            public boolean onQueryTextChange(String newText) {
                return false;
            }
        });
        assert mapFragment != null;
        mapFragment.getMapAsync(PickMap.this);
    }
    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        // change the marker color on map
        myMap = googleMap;
    }

}
