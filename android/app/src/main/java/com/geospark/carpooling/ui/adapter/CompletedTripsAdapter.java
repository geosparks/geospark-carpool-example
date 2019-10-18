package com.geospark.carpooling.ui.adapter;


import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.geospark.carpooling.R;
import com.geospark.carpooling.model.TripsCompleted;
import com.geospark.carpooling.ui.TripHistoryMapActivity;
import com.geospark.carpooling.util.DateTime;

import java.util.ArrayList;
import java.util.List;

public class CompletedTripsAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private Context mContext;

    public CompletedTripsAdapter(Context context) {
        this.mContext = context;
    }

    private List<TripsCompleted> mCompletedTrips = new ArrayList<>();

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_trip, parent, false);
        return new ItemViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, int position) {
        final TripsCompleted row = mCompletedTrips.get(position);
        try {
            ((ItemViewHolder) viewHolder).mTxtName.setText("TripId: " + row.getId());
            ((ItemViewHolder) viewHolder).mTxtStart.setText("Started At: " + DateTime.utcToLocal(row.getTripStart()));
            ((ItemViewHolder) viewHolder).mTxtEnd.setText("Ended At: " + DateTime.utcToLocal(row.getTripEnd()));
            ((ItemViewHolder) viewHolder).mItem.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    mContext.startActivity(new Intent(mContext, TripHistoryMapActivity.class).putExtra("COORDINATES", row));
                }
            });
        } catch (Exception e) {
        }
    }

    public void addAll(List<TripsCompleted> items) {
        mCompletedTrips.clear();
        mCompletedTrips.addAll(items);
        notifyDataSetChanged();
    }


    @Override
    public int getItemCount() {
        return mCompletedTrips.size();
    }

    class ItemViewHolder extends RecyclerView.ViewHolder {
        private TextView mTxtName;
        private TextView mTxtStart;
        private TextView mTxtEnd;
        private LinearLayout mItem;

        ItemViewHolder(View view) {
            super(view);
            mTxtName = view.findViewById(R.id.txt_name);
            mTxtStart = view.findViewById(R.id.txt_start);
            mTxtEnd = view.findViewById(R.id.txt_end);
            mItem = view.findViewById(R.id.item);
        }
    }
}
