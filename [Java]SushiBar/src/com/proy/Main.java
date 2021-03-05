package com.proy;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) throws InterruptedException {
        Scanner scan = new Scanner(System.in);
        int N = scan.nextInt();
        int M = scan.nextInt();
        int t = scan.nextInt();
        int T = scan.nextInt();

        Bar bar = new Bar(N, M);
        Joven[] joven = new Joven[N];
        for (int i = 0; i < N; i++){
            joven[i] = new Joven(i, bar, t, T/t);
            joven[i].start();
        }

        for (int i = 0; i < N; i++)
            joven[i].join();
    }
}
