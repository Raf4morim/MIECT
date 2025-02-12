package com.example.touristGuide_app.Adapters;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.CenterCrop;
import com.bumptech.glide.load.resource.bitmap.GranularRoundedCorners;
import com.example.touristGuide_app.Activities.DetailActivity;
import com.example.touristGuide_app.Domains.ListEventsDomain;
import com.example.touristGuide_app.R;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Locale;

public class ListEventsAdapter extends RecyclerView.Adapter<ListEventsAdapter.ViewHolder> {
    ArrayList<ListEventsDomain> items;
    Context context;

    public ListEventsAdapter(Context context, ArrayList<ListEventsDomain> items) {
        this.context = context;
        this.items = items;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View inflate = LayoutInflater.from(parent.getContext()).inflate(R.layout.viewholder_events, parent, false);
        return new ViewHolder(inflate);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        ListEventsDomain event = items.get(position);

        holder.titleTxt.setText(event.getName());
        holder.organizerTxt.setText(event.getOrganizer());
        holder.aboutTxt.setText(event.getAbout());
        holder.locationTxt.setText(event.getPointOfInterest().getLocationName());
        holder.contactTxt.setText(event.getContact());
        holder.categoryOfPoiTxt.setText(event.getPointOfInterest().getCategory());
        holder.maxParticipantsTxt.setText(String.valueOf(event.getMaxParticipants()));
        holder.currentParticipantsTxt.setText(String.valueOf(event.getCurrentParticipants()));
        holder.priceOfEventTxt.setText(event.getCurrency() + " " + String.valueOf(event.getPrice()));
        // Formatação das datas
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault());
        holder.startDateTxt.setText(dateFormat.format(event.getStartDate()));
        holder.endDateTxt.setText(dateFormat.format(event.getEndDate()));
        // Uso do Glide para carregar a imagem do thumbnail
        Glide.with(holder.itemView.getContext())
                .load(event.getPointOfInterest().getThumbnail())
                .into(holder.thumbnailImg);

        // Adicione o OnClickListener
        holder.itemView.setOnClickListener(v -> {
            Intent intent = new Intent(context, DetailActivity.class);
            intent.putExtra("userIdReq", event.getUserIdReq());
            System.out.println("userIdReqqqqqqqqqqq"+ event.getUserIdReq());
            intent.putExtra("calendarIdReq", event.getCalendarIdReq());
            System.out.println("calendarIdReqqqqqqqqqqq"+ event.getCalendarIdReq());
            intent.putExtra("eventId", event.getId());
            context.startActivity(intent);
        });
    }
    @Override
    public int getItemCount() {
        return items.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView titleTxt, organizerTxt, aboutTxt, locationTxt, contactTxt, categoryOfPoiTxt, maxParticipantsTxt, currentParticipantsTxt, priceOfEventTxt, startDateTxt, endDateTxt;
        ImageView thumbnailImg;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            titleTxt = itemView.findViewById(R.id.nameTxt);
            organizerTxt = itemView.findViewById(R.id.organizer_txt);
            aboutTxt = itemView.findViewById(R.id.about_txt);
            locationTxt = itemView.findViewById(R.id.location_txt);
            contactTxt = itemView.findViewById(R.id.contact_txt);
            categoryOfPoiTxt = itemView.findViewById(R.id.category_of_poi_txt);
            maxParticipantsTxt = itemView.findViewById(R.id.max_participants_txt);
            currentParticipantsTxt = itemView.findViewById(R.id.current_participants_txt);
            priceOfEventTxt = itemView.findViewById(R.id.price_of_event_txt);
            startDateTxt = itemView.findViewById(R.id.startDateTxt);
            endDateTxt = itemView.findViewById(R.id.endDateTxt);
            thumbnailImg = itemView.findViewById(R.id.thumbnailImg);
        }
    }
}

