package com.smartseat.model;

public class Room {
    private int id;
    private String roomNo;         // Example: N001, O101
    private String buildingBlock;  // Example: 'New Building (B-Block)' or 'Old Building (A-Block)'
    private int floor;             // Example: 0 (Ground), 1, 2, 3
    private int totalColumns;
    private int benchesPerColumn;

    public Room() {}

    public Room(String roomNo, String buildingBlock, int floor, int totalColumns, int benchesPerColumn) {
        this.roomNo = roomNo;
        this.buildingBlock = buildingBlock;
        this.floor = floor;
        this.totalColumns = totalColumns;
        this.benchesPerColumn = benchesPerColumn;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    public String getBuildingBlock() { return buildingBlock; }
    public void setBuildingBlock(String buildingBlock) { this.buildingBlock = buildingBlock; }

    public int getFloor() { return floor; }
    public void setFloor(int floor) { this.floor = floor; }

    public int getTotalColumns() { return totalColumns; }
    public void setTotalColumns(int totalColumns) { this.totalColumns = totalColumns; }

    public int getBenchesPerColumn() { return benchesPerColumn; }
    public void setBenchesPerColumn(int benchesPerColumn) { this.benchesPerColumn = benchesPerColumn; }

    public int getCapacity() {
        return totalColumns * benchesPerColumn * 2; // Default 2 students per bench
    }
}