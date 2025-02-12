package com.example.touristGuide_app.Adapters;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.example.touristGuide_app.Activities.DetailActivity;
import com.example.touristGuide_app.Domains.ListEventsDomain_per_day;
import com.example.touristGuide_app.R;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Locale;

public class ListEventsAdapter_per_day extends RecyclerView.Adapter<ListEventsAdapter_per_day.ViewHolder> {
    ArrayList<ListEventsDomain_per_day> items;
    Context context;
    OnEventClickListener onEventClickListener;

    public ListEventsAdapter_per_day(Context context, ArrayList<ListEventsDomain_per_day> items, OnEventClickListener onEventClickListener) {
        this.context = context;
        this.items = items;
        this.onEventClickListener = onEventClickListener;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View inflate = LayoutInflater.from(parent.getContext()).inflate(R.layout.viewholder_events_per_day, parent, false);
        return new ViewHolder(inflate, onEventClickListener);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        ListEventsDomain_per_day event = items.get(position);

        holder.titleTxt.setText(event.getName());
        holder.organizerTxt.setText(event.getOrganizer());
        holder.aboutTxt.setText(event.getAbout());
        holder.locationTxt.setText(event.getPointOfInterest().getLocationName());
        holder.contactTxt.setText(event.getContact());
        holder.categoryOfPoiTxt.setText(event.getCategory());
        holder.maxParticipantsTxt.setText(String.valueOf(event.getMaxParticipants()));
        holder.currentParticipantsTxt.setText(String.valueOf(event.getCurrentParticipants()));
        holder.priceOfEventTxt.setText(String.format("%s %.2f", event.getCurrency(), event.getPrice()));
        holder.startDateTxt.setText(event.getStartDate().toString());
        holder.endDateTxt.setText(event.getEndDate().toString());

        // Use Glide or Picasso to load images
        Glide.with(context)
                .load(event.getPointOfInterest().getThumbnail())
                .into(holder.thumbnailImg);
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    public ListEventsDomain_per_day getEvent(int position) {
        return items.get(position);
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView titleTxt, organizerTxt, aboutTxt, locationTxt, contactTxt, categoryOfPoiTxt, maxParticipantsTxt, currentParticipantsTxt, priceOfEventTxt, startDateTxt, endDateTxt;
        ImageView thumbnailImg;
        ImageView favoritesIcon;
        OnEventClickListener onEventClickListener;

        public ViewHolder(@NonNull View itemView, OnEventClickListener onEventClickListener) {
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
            favoritesIcon = itemView.findViewById(R.id.favorites_icon);

            this.onEventClickListener = onEventClickListener;
            favoritesIcon.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            onEventClickListener.onEventClick(getAdapterPosition());
        }
    }

    public interface OnEventClickListener {
        void onEventClick(int position);
    }
}


