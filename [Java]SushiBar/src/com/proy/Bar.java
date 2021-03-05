package com.proy;

import static java.lang.Thread.sleep;

public class Bar {
    private boolean[] eating;
    private Plato[] dishes;
    private Plato[] table;
    private int N, n_rolls, count, point;
    private String[] states;

    public Bar(int N_, int n) {
        N = N_;
        eating = new boolean[N];
        dishes = new Plato[N];
        table = new Plato[N];
        for(int i = 0; i < N; i++) {
            dishes[i] = new Plato(i+1);
            table[N -1 -i] = dishes[i];
        }
        n_rolls = n;
        count = 0;
        states = new String[N];
        point = -1;
    }

    public synchronized void set_com(int i, boolean val) {
        eating[i] = val;
        if(val) table[i].comer();
    }

    public synchronized boolean pc(int i) {
        //System.out.printf("Joven %d intentando comer de plato %d con rolls %d%n", i+1, table[i].get_id(), table[i].get_rolls());
        return !eating[(i + 1) % N] && !eating[((N - 1) + i) % N] && table[i].get_rolls() > 0;
    }

    public synchronized void print_dish() throws InterruptedException {
        count++;
        if (count < N) {
            wait();
        } else {
            for (int i = 0; i < N; i++) {
                System.out.printf("P%d: %d ", i + 1, dishes[i].get_rolls());
            }
            System.out.printf("%n");
            count = 0;
            notifyAll();
        }
    }

    public synchronized void sync(int t) throws InterruptedException {
        count++;
        if(count < N) {
            wait();
        } else {
            if(t != 0) {
                sleep(t*1000);
            }
            count = 0;
            notifyAll();
        }
    }

    public synchronized void fill() throws InterruptedException {
        count++;
        if(count < N) {
            wait();
        } else {
            for (int i = (point+1) % 5; i != point; i += (i+1) % N) {
                if (dishes[i].get_rolls() == 0) {
                    dishes[i].fill(n_rolls);
                    point = i;
                    break;
                }
            }
            count = 0;
            notifyAll();
        }
    }

    public synchronized void shift() throws InterruptedException {
        count++;
        if(count < N) {
            wait();
        } else {
            Plato aux = table[N-1];
            for (int i = N-1; i > 0; i--) {
                table[i] = table[i-1];
            }
            table[0] = aux;
            count = 0;
            notifyAll();
        }
    }

    public synchronized void print(int id, String estado) throws InterruptedException {
        states[id] = estado;
        count++;
        if(count < N) {
            wait();
        } else {
            for (int i = 0; i < N; i++) {
                System.out.printf("J%d: %s ", i + 1, states[i]);
            }
            System.out.printf("%n");
            count = 0;
            notifyAll();
        }
    }
}
