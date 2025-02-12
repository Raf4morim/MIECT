package com.example.touristGuide_app.Adapters;

import android.content.Intent;
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
import com.example.touristGuide_app.Activities.ListOfEvents;
import com.example.touristGuide_app.Domains.PointOfInterestDomain;
import com.example.touristGuide_app.R;
import java.util.ArrayList;

public class PointOfInterestAdapter extends RecyclerView.Adapter<PointOfInterestAdapter.ViewHolder> {
    ArrayList<PointOfInterestDomain> items;
    private int userIdReq;
    private int calendarIdReq;
    private String id_poi;
    public PointOfInterestAdapter(ArrayList<PointOfInterestDomain> items, int userIdReq, int calendarIdReq, String id_poi) {
        this.items = items;
        this.userIdReq = userIdReq;
        this.calendarIdReq = calendarIdReq;
        this.id_poi = id_poi;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View inflate = LayoutInflater.from(parent.getContext()).inflate(R.layout.viewholder_poi, parent, false);
        return new ViewHolder(inflate);
    }
    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        PointOfInterestDomain item = items.get(position);
        holder.nameTxt.setText(item.getName());
        holder.descriptionTxt.setText(item.getDescription());
        holder.locationTxt.setText(item.getLocationName());
        holder.categoryOfPoiTxt.setText(item.getCategory());

        // Verifique se o thumbnail é um URL ou um nome de recurso local
        String thumbnail = item.getThumbnail();
        if (thumbnail.startsWith("http")) {
            // Carregar imagem de URL
            Glide.with(holder.itemView.getContext())
                    .load(thumbnail)
                    .transform(new CenterCrop(), new GranularRoundedCorners(20, 20, 20, 20))
                    .into(holder.thumbnail);
        } else {
            // Carregar imagem de recurso local
            int resourceId = holder.itemView.getContext().getResources().getIdentifier(thumbnail, "drawable", holder.itemView.getContext().getPackageName());
            Glide.with(holder.itemView.getContext())
                    .load(resourceId)
                    .transform(new CenterCrop(), new GranularRoundedCorners(20, 20, 20, 20))
                    .into(holder.thumbnail);
        }

        // AqUI

        holder.itemView.setOnClickListener(v -> {
            Intent intent = new Intent(holder.itemView.getContext(), ListOfEvents.class);
            intent.putExtra("userIdReq", userIdReq);
            intent.putExtra("calendarIdReq", calendarIdReq);
            intent.putExtra("poiId", item.getId());


            holder.itemView.getContext().startActivity(intent);
        });
    }
    @Override
    public int getItemCount() {
        return items.size();
    }
    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView nameTxt, locationTxt, descriptionTxt, categoryOfPoiTxt;
        ImageView thumbnail;
        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            nameTxt = itemView.findViewById(R.id.nameTxt);
            descriptionTxt = itemView.findViewById(R.id.descriptionTxt);
            locationTxt = itemView.findViewById(R.id.locationTxt);
            categoryOfPoiTxt = itemView.findViewById(R.id.categoryOfPoiTxt);
            thumbnail = itemView.findViewById(R.id.thumbnailImg);
        }
    }
}