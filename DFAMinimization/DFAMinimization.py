#!/usr/bin/env python3

def unpack(l):
    for i in l:
        if isinstance(i, tuple):
            l.append(i[0])
            l.append(i[1])
            l.remove(i)
            unpack(l)

    return l

def form(l):
    l = list(map(str, l))
    return '-'.join(l)


def readval():
    temp = input()
    tempp = temp.strip().split(" ")
    n = int(tempp[0])
    s = int(tempp[1])
    q = list(range(n))
    alph = []
    delta = {}
    estfn = input()
    estfin = estfn.strip().split(" ")
    f = list(map(int, estfin))
    t = input()
    
    while not t == ".":
        te = t.strip().split(" ")

        if te[2] not in alph:
            alph.append(te[2])

        try:
            delta[int(te[0])][te[2]] = int(te[1])
        except KeyError:
            delta[int(te[0])] = {}
            delta[int(te[0])][te[2]] = int(te[1])
        t = input()

    alph.sort()
    return (q, alph, delta, s, f)

def separate(a, delta):
    out1 = []
    out2 = []
    for s in a:
        bul = False
        for q in list(delta[s].values()):
            if q not in a:
                bul = True
        if bul:
            out2.append(s)
        else:
            out1.append(s)

    if out1 == []:
        return out2
    elif out2 == []:
        return out1
    else:
        one = separate(out1, delta)
        two = separate(out2, delta)
        return one, two


def minimize(delta, finalstates, states):
    final = []
    nonfinal = []
    final = finalstates
    for state in states:
        if state not in final:
            nonfinal.append(state)

    one = separate(final, delta)
    two = separate(nonfinal, delta)
    return one, two

def main():
    numcase = int(input().strip())

    for case in range(numcase):
        states, alph, delta, start, final = readval()
        
        epa = [minimize(delta, final, states)]

        newafd = unpack(epa)

        newstart = start
        newfinal = []
        newnonfinal = []
        mapping = {}
        newdelta = {}

        for i in newafd:
            if start in i: newstart = i
            for j in final:
                if j in i and i not in newfinal:
                    newfinal.append(i)

        for i in newafd:
            if i not in newfinal:
                newnonfinal.append(i)

        for i in delta.keys():
            for j in newafd:
                if i in j:
                    mapping[i] = j

        for k, v in mapping.items():
            newdelta[tuple(v)] = delta[k]
            for kk, vv in newdelta[tuple(v)].items():
                newdelta[tuple(v)][kk] = mapping[vv]

        newstart = form(newstart)
        newfinal = list(map(form, newfinal))
        newnonfinal = list(map(form, newnonfinal))

        print(f"Caso {case+1}:")
        print(newstart)
        print(' '.join(newfinal))
        print(' '.join(newnonfinal))
        for k, v in newdelta.items():
            for kk, vv in v.items():
                pr = f'{form(k)} {form(vv)} {kk}'
                print(pr)


if __name__ == '__main__':
    main()