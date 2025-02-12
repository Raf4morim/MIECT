package com.example.touristGuide_app.Adapters;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.bumptech.glide.Glide;
import com.example.touristGuide_app.R;
import com.example.touristGuide_app.Domains.CategoryDomain;
import java.util.ArrayList;
import java.util.HashMap;

public class CategoryAdapter extends RecyclerView.Adapter<CategoryAdapter.ViewHolder> {
    private OnCategorySelectedListener listener;
    private ArrayList<CategoryDomain> items;
    private HashMap<String, Integer> categoryImageMap;

    public CategoryAdapter(ArrayList<CategoryDomain> items, OnCategorySelectedListener listener) {
        this.items = items;
        this.listener = listener;
        this.categoryImageMap = initializeCategoryImageMap();
    }

    private HashMap<String, Integer> initializeCategoryImageMap() {
        HashMap<String, Integer> map = new HashMap<>();
        map.put("Nature", R.drawable.cat1);
        map.put("Food", R.drawable.cat2);
        map.put("Culture", R.drawable.cat3);
        map.put("Shopping", R.drawable.cat4);
        map.put("Landmarks", R.drawable.cat5);
        return map;
    }

    @NonNull
    @Override
    public CategoryAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View inflate = LayoutInflater.from(parent.getContext()).inflate(R.layout.viewholder_category, parent, false);
        return new ViewHolder(inflate);
    }

    @Override
    public void onBindViewHolder(@NonNull CategoryAdapter.ViewHolder holder, int position) {
        CategoryDomain category = items.get(position);
        holder.titleTxt.setText(category.getTitle());

        Integer drawableResourceId = categoryImageMap.get(category.getTitle());
        if (drawableResourceId != null) {
            Glide.with(holder.itemView.getContext()).load(drawableResourceId).into(holder.picImg);
        }

        if (holder.isSelected) {
            holder.itemView.setBackgroundResource(R.drawable.category_bg_selected);
        } else {
            holder.itemView.setBackgroundResource(R.drawable.category_bg);
        }

        holder.itemView.setOnClickListener(v -> {
            holder.isSelected = !holder.isSelected;
            notifyDataSetChanged();
            if (holder.isSelected) {
                listener.onCategorySelected(category.getTitle());
            } else {
                listener.onCategoryDeselected(category.getTitle());
            }
        });
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        TextView titleTxt;
        ImageView picImg;
        boolean isSelected;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            titleTxt = itemView.findViewById(R.id.titleTxt);
            picImg = itemView.findViewById(R.id.catImg);
            isSelected = false;
        }
    }

    public interface OnCategorySelectedListener {
        void onCategorySelected(String category);
        void onCategoryDeselected(String category);
    }
}
