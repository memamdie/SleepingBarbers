/*Quiz 3.1*/

Function Q311M(i, r)


End Function


Function Q312I(i, n, r)
((147000*.148) + 147000)*.148 +((147000*.148) + 147000)

End Function

Function Q314()
/*Quiz 3.2*/

Function Q321I(A, n, r)

    Q321I = A * ((1 - (1 + r) ^ -n) / r)

End Function


Function Q322F(A, n, r)

    Q322F = A * (((1 + r) ^ n - 1) / r)

End Function


Function Q323A(F, r)

    Q323A = F * r
End Function

/*Quiz 3.3*/

Function Q331A(m, n, P, r)

    Q331A = P * r / (((1 + r) ^ -m) * (1 - (1 + r) ^ -n))

End Function


Function Q331P(A, m, n, r)

    Q331P = ((1 + r) ^ -m) * (1 - (1 + r) ^ -n) * A / r

End Function


Function Q332A(r, x1, x2, x3)
    Dim P1 As Double
        P1 = x1 + x2 * (1 + r) ^ -1 + x3 * (1 + r) ^ -2
    Dim P2 As Double
        P2 = (1 + (1 + r) ^ -1 + (1 + r) ^ -2)

    Q332A = P1 / P2

End Function


Function Q333P(A, k, n, r)

    Q333P = (A / r) * (1 - (1 + r) ^ (-(n - (k - 1))))

End Function

Function F1P0i0n(P, i, n, disp)
    '(F/P, i, n)
    'F = P(1+r)^n

    If disp Then
      F1P0i0n = "F = P(1+r)^n"
    Else
      F1P0i0n = P * (1+r)^n
    End If

End Function


Function e_APR_fnMr0r1r2(f, n, M, r0, r1, r2, disp)

Dim A_a As Double, Pa_1 As Double, Pa_2 As Double
  If disp Then
      e_APR_fnMr0r1r2 = "r1*Pa2 - r2*Pa1/Pa2-Pa1"
  Else
      A_a = (M*M*(((r0/12)*(1+(r0/12)^n))/((1+(r0/12)^n)-1))) + f
      Pa_1 = A_a*(1-(1+r1)^(-n))/r1
      Pa_2 = A_a*(1-(1+r2)^(-n))/r2
      e_APR_fnMr0r1r2 = ((r1*Pa_2)-(r2*Pa_1))/(Pa2-Pa1)

End Function
