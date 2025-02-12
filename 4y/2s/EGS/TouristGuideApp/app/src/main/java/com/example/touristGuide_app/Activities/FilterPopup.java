package com.example.touristGuide_app.Activities;

import static android.app.Activity.RESULT_OK;

import android.content.Context;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.text.InputType;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.touristGuide_app.Adapters.CategoryAdapter;
import com.example.touristGuide_app.Domains.CategoryDomain;
import com.example.touristGuide_app.R;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class FilterPopup extends DialogFragment implements CategoryAdapter.OnCategorySelectedListener{
    private RecyclerView.Adapter adapterCategory;
    private RecyclerView recyclerViewCategory;
    private OnFilterAppliedListener filterAppliedListener;
    private OnLocationSelectedListener locationSelectedListener;
    private EditText editTextLocationName;
    private int selectedCategoryIndex = -1;
    private double latitude = 0, longitude = 0; // Variável para armazenar a longitude recebida
    private String selectedCategory = null;
    private float selectedRadius = 0;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
            @Nullable Bundle savedInstanceState) {

        // Inflar o layout do seu popup
        View view = inflater.inflate(R.layout.filter_popup, container, false);
        // Inicialize o RecyclerView
        initRecyclerView(view);
        // Acessar a EditText e armazená-la como uma variável de instância
        editTextLocationName = view.findViewById(R.id.editTextLocationName);
        SeekBar seekBar = view.findViewById(R.id.seekBarRadius); // Configurar o SeekBar para mostrar o valor em Kms
        final TextView textViewRadius = view.findViewById(R.id.textViewRadius);
        // Configurar o botão PIN do mapa para procurar cidade
        FloatingActionButton btnPin = view.findViewById(R.id.btnPin);
        btnPin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Abrir a atividade PickMap
                Intent intent = new Intent(getActivity(), PickMap.class);
                startActivityForResult(intent, 1);
            }
        });

        // Definir o intervalo do SeekBar de 0 a 50000 (para 0.1 km a 50 km)
        seekBar.setMax(50000);
        seekBar.setProgress(100); // Ponto inicial em 100 metros
        seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                // Ajustar o valor mínimo para 100 metros
                selectedRadius = (progress + 100); //  1000f; // Converter para Kms, mínimo de 0.1 km
                // Atualizar o texto da descrição com o valor em Kms
                textViewRadius.setText("Define a radius to find one place: \n" + selectedRadius/1000f + " kms");
            }
            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }
            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });


        Button applyFiltersButton = view.findViewById(R.id.btnApplyFilter);
        applyFiltersButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                applyFilters();
            }
        });

        // Retornar a view inflada
        return view;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1 && resultCode == RESULT_OK && data != null) {
            double latitude = data.getDoubleExtra("latitude", 0);
            double longitude = data.getDoubleExtra("longitude", 0);
            updateLocation(latitude, longitude); // Atualize as coordenadas no popup
        }
    }
    private void initRecyclerView(View view){
        // Initialize RecyclerView and adapter for categories
        // Lista de categorias
        ArrayList<CategoryDomain> catsList = new ArrayList<>();
        catsList.add(new CategoryDomain("Nature"));
        catsList.add(new CategoryDomain("Food"));
        catsList.add(new CategoryDomain("Culture"));
        catsList.add(new CategoryDomain("Shopping"));
        catsList.add(new CategoryDomain("Landmarks"));

        // Configuração do RecyclerView e do adapter
        recyclerViewCategory = view.findViewById(R.id.viewCat);
        recyclerViewCategory.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false));
        adapterCategory = new CategoryAdapter(catsList, this);
        recyclerViewCategory.setAdapter(adapterCategory);
    }
    @Override
    public void onCategoryDeselected(String category) {
        // Implementar a lógica de desselecionar uma categoria, se necessário
        if (selectedCategory != null && selectedCategory.equals(category)) {
            selectedCategory = null;
        }
    }
    @Override
    public void onCategorySelected(String category) {
        // Atualizar a categoria selecionada
        selectedCategory = category;
    }
    public void applyFilters() {
        // Coletar os valores dos filtros
        String locationName = editTextLocationName.getText().toString(); // Renomeado de postcode

        // Aplica os filtros passando os dados de volta para a atividade principal
        if (filterAppliedListener != null) {
            filterAppliedListener.onFilterApplied(latitude, longitude, locationName, selectedRadius, selectedCategory);
        }

        dismiss(); // Fecha o popup após aplicar o filtro
    }

    public void updateLocation(double latitude, double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;

        // Obter o nome da localização usando geocodificação reversa
        Geocoder geocoder = new Geocoder(getActivity(), Locale.getDefault());
        try {
            List<Address> addresses = geocoder.getFromLocation(latitude, longitude, 1);
            if (!addresses.isEmpty()) {
                Address address = addresses.get(0);
                // Extrair a cidade ou outra parte do endereço que deseja
                String cityName = address.getLocality(); // Obtém o nome da cidade
                if (cityName != null && !cityName.isEmpty()) {
                    // Atualize a exibição das coordenadas e da localização
                    TextView textViewLocationName = getView().findViewById(R.id.textViewLocationName);
                    textViewLocationName.setText(String.format("Pick a location to visit:\n%s\nLatitude: %.6f\nLongitude: %.6f", cityName, latitude, longitude));

                    // Preencher automaticamente o EditText com o nome da cidade
                    editTextLocationName.setText(cityName);
                } else {
                    // Se a cidade não estiver disponível, exiba apenas as coordenadas
                    TextView textViewLocationName = getView().findViewById(R.id.textViewLocationName);
                    textViewLocationName.setText(String.format("Pick a location to visit:\nLatitude: %.6f\nLongitude: %.6f", latitude, longitude));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void setOnLocationSelectedListener(OnLocationSelectedListener listener) {
        this.locationSelectedListener = listener;
    }

    public void setOnFilterAppliedListener(OnFilterAppliedListener listener) {
        this.filterAppliedListener = listener;
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        try {
            filterAppliedListener = (OnFilterAppliedListener) context;
            locationSelectedListener = (OnLocationSelectedListener) context;
        } catch (ClassCastException e) {
            throw new ClassCastException(context.toString() + " must implement OnFilterAppliedListener and OnLocationSelectedListener");
        }
    }
}