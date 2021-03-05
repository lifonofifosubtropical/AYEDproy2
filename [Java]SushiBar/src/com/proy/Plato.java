package com.proy;


public class Plato {
    private int n_rolls;
    private int id;

    public Plato(int id) {
        this.id = id;
        n_rolls = 0;
    }

    public int get_rolls() {
        return n_rolls;
    }

    public synchronized void fill(int n) {
        n_rolls = n;
    }

    public void comer() {
        n_rolls--;
    }

    public int get_id() {
        return id;
    }

}