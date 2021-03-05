package com.proy;

public class Joven extends Thread {
    private String estado;// last_estado;
    private int id, ron_tot, cont, t;
    private Bar bar;

    public Joven(int i, Bar bar, int t, int round) {

        estado = "Teléfono";
        id = i;
        this.bar = bar;
        ron_tot = round;
        this.t = t;
    }

    public void run() {
        try {
            bar.shift();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        try {
            bar.sync(0);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        try {
            bar.fill();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        while(cont != ron_tot) {
            try {
                bar.print_dish();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            try {
                bar.sync(0);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            if(bar.pc(id) && !estado.equals("Comiendo")) {
                estado = "Comiendo";
                bar.set_com(id, true);
            } else {
                estado = "Teléfono";
            }

            try {
                bar.sync(0);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            try {
                bar.print(id, estado);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            bar.set_com(id, false);

            try {
                bar.sync(0);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            try {
                bar.sync(0);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            try {
                bar.fill();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            try {
                bar.sync(0);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            try {
                bar.shift();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            try {
                bar.sync(t);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            cont++;
        }
    }
}
