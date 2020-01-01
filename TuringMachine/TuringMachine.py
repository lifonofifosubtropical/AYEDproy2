#!/usr/bin/env python3

def readval():
    nstates = int(input().strip())
    tsymbol = input().strip().split(' ')
    delta = {}
    strings = []

    while True:
        ofled = input().strip().split()
        if len(ofled) < 5:
            break
        try:
            delta[int(ofled[0])][ofled[2]] = (int(ofled[1]), ofled[3], ofled[4])
        except KeyError:
            delta[int(ofled[0])] = {}
            delta[int(ofled[0])][ofled[2]] = (int(ofled[1]), ofled[3], ofled[4])

    nstrings = int(ofled[0])
    for i in range(nstrings):
        strings += input().strip().split()
    return (nstates, delta, strings)

def analyzer(nstates, delta, string):
    index = 0
    state = 0
    string = list(string)

    while True:
        if state == nstates-1:
            return 'aceptada'

        if index == -1:
            string = ['-'] + string + ['-']
            index += 1
            
        try:
            symbol = string[index]
        except IndexError:
            string = ['-'] + string + ['-']
            index += 1
            symbol = string[index]

        try:
            state, string[index], direction = delta[state][symbol]

            if direction == 'L':
                index -= 1
            elif direction == 'R':
                index += 1


        except KeyError:
            return 'rechazada'

def main():
    numcase = int(input().strip())
    for case in range(numcase):
        nstates, delta, strings = readval()
        print(f'Caso {case + 1}:')
        for string in strings:
            print(analyzer(nstates, delta, string))

if __name__ == '__main__':
    main()
