'Attribute VB_Name = "DontMessWithCS"
'--- --- --- --- --- --- --- --- --- --- --- ---
'Quiz 3.2
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Q321I_Anr(A, n, r, disp)
'F = A*(1-(1+r)^-n)/r

    If disp Then
      e_Q321I_Anr = "F = A*(1-(1+r)^-n)/r "
    Else
      e_Q321I_Anr = A * ((1 - (1 + r) ^ -n) / r)
    End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Q322F_Anr(A, n, r, disp)
'F = A*(((1+r)^n - 1)/r

    If disp Then
      e_Q322F_Anr = "F = A*(((1+r)^n - 1)/r "
    Else
      e_Q322F_Anr = A * (((1 + r) ^ n - 1) / r)
    End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Q323A_Fr(F, r, disp)
'F = A*(1-(1+r)^-n)/r
    If disp Then
      e_Q323A_Fr = "F = A*(1-(1+r)^-n)/r , n = inf"
    Else
      e_Q323A_Fr = F * r
    End If

End Function

'--- --- --- --- --- --- --- --- --- --- --- ---
'Quiz 3.3
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Q331A_mnPr(m, n, P, r, disp)
'A = P * r / (1 - (1+r)^-n)

    If disp Then
      e_Q331A_mnPr = "A = P * r / (1 - (1+r)^-n)"
    Else
      e_Q331A_mnPr = P * r / (1 - (1 + r) ^ -n)
    End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Q331P_Amnr(A, m, n, r, disp)
'P = (1+r)^-m * A * ((1-(1+r)^-n)/r)

    If disp Then
      e_Q331P_Amnr = "P = (1+r)^-m * A * ((1-(1+r)^-n)/r)"
    Else
      e_Q331P_Amnr = (A * (1 - (1 + r) ^ -n)) / r
    End If

End Function

'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Q332A_rxxx(r, x1, x2, x3, disp)
'P1 = x1 + x2(1+r)^-1 + x3(1+r)^-2
'P2 = A(1 + (1+r)^-1 + (1+r)^-2)

    If disp Then
      e_Q332A_rxxx = "P1 = x1 + x2(1+r)^-1 + x3(1+r)^-2 and P2 = A(1 + (1+r)^-1 + (1+r)^-2)"
    Else
      e_Q332A_rxxx = (x1 + (x2 * (1 + r) ^ -1) + (x3 * (1 + r) ^ -2)) / (1 + (1 + r) ^ -1 + (1 + r) ^ -2)
    End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Q333_Inkr(initial, n, period, r, disp)
  'A(1-(1+r)^(-n+k-1))/r

    If disp Then
      e_Q333_Inkr = "Portion = A(1+r)^(-n+k-1)"
    Else
      e_Q333_Inkr = initial * (1 - (1 + r) ^ (-(n - (period - 1)))) / r
    End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
' Michelle's Functions that conform to Cory's dictator-like naming constraints
' They make it easier to identify the equations from their names!
' Fair enough it does make sense lol
'--- --- --- --- --- --- --- --- --- --- --- ---

'--- --- --- --- --- --- --- --- --- --- --- ---
'Learning Curve Model
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_LearningCurve_ProducenUnits_Tnr(T, n, r, disp)
'T_n = T_1 * n^b
  If disp Then
    e_LearningCurve_ProducenUnits_Tnr = "Tn =  T1 * r^(log2(n))"
  Else
    e_LearningCurve_ProducenUnits_Tnr =  T * r^(Log(n) / Log(2))
  End If

End Function



'--- --- --- --- --- --- --- --- --- --- --- ---
'Compound Interest
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_F1P0i0n(P, i, n, disp)
'(F/P,i,n)
'F = P(1+r)^n

    If disp Then
        e_F1P0i0n = "F = P(1+i)^n"
    Else
        e_F1P0i0n = P * (1 + i) ^ n
    End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_P1F0i0n(F, i, n, disp)
'(P/F, i, n)
'P = F*(1+i)^-n

  If disp Then
    e_P1F0i0n = "P = F*(1+i)^-n"
  Else
    e_P1F0i0n = F*(1+i)^-n
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_PrincipalBegin_Prn(P, r, n, disp)
'P_n = P * (1 + r)^ (n - 1)
  If disp Then
    e_PrincipalBegin_Prn = "Pn = P * (1 + r)^ (n - 1)"
  Else
    e_PrincipalBegin_Prn = P * (1 + r)^ (n - 1)
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Interest4Period_Prn(P, r, n, disp)
'r_P = r * P * (1+r)^(n-1)
'
  If disp Then
    e_Interest4Period_Prn = "rP = r * P * (1+r)^(n-1)"
  Else
    e_Interest4Period_Prn = r * P * (1+r)^(n-1)
  End If

End Function

'--- --- --- --- --- --- --- --- --- --- --- ---
'Simple Interest
'--- --- --- --- --- --- --- --- --- --- --- ---

Function e_SimpleInterestFuture_Prn(P, r, n, disp)
'F = P * (1 + (n * r))
'
  If disp Then
    e_SimpleInterestFuture_Prn = "F = P * (1 + (n * r))"
  Else
    e_SimpleInterestFuture_Prn = P * (1 + (n * r))
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_SimpleInterestPresent_Frn(F, r, n, disp)
'P = F / (1 + (n * r))
'
  If disp Then
    e_SimpleInterestPresent_Frn = "P = F / (1 + (n * r))"
  Else
    e_SimpleInterestPresent_Frn = F / (1 + (n * r))
  End If

End Function

'--- --- --- --- --- --- --- --- --- --- --- ---
'Nominal and Effective Interest Rates
'--- --- --- --- --- --- --- --- --- --- --- ---

Function e_Nominal_rn(r, n, disp)
'r = n * r_x
'
  If disp Then
    e_Nominal_rn = " r = n * rx"
  Else
    e_Nominal_rn = n * r
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_Effective_rn(r, n, disp)
'r_a = (1 + (r/n))^n - 1
'
  If disp Then
    e_Effective_rn = " ra = (1 + (r/n))^n - 1"
  Else
    e_Effective_rn = (1 + (r/n))^n - 1
  End If

End Function

'--- --- --- --- --- --- --- --- --- --- --- ---
'Uniform Series
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_F1A0i0n(A, i, n, disp)
'(F/A, i, n)
'F = A * ((1 + i) ^ n - 1) / i)

  If disp Then
    e_F1A0i0n = "F = A * ((1 + i) ^ n - 1) / i)"
  Else
    e_F1A0i0n = A * (((1 + i) ^ n - 1) / i)
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_A1F0i0n(F, i, n, disp)
'(A/F, i, n)
'A = F * (i / ((1 + i)^n - 1))

  If disp Then
    e_A1F0i0n = "A = F * (i / ((1 + i)^n - 1))"
  Else
    e_A1F0i0n = F * (i / ((1 + i)^n - 1))
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_A1P0i0n(P, i, n, disp)
'(A/P, i, n)
'A = P * ((i * (1 + i)^n) / ((1 + i)^n - 1))

  If disp Then
    e_A1P0i0n = "A = P * ((i * (1 + i)^n) / ((1 + i)^n - 1))"
  Else
    e_A1P0i0n = P * ((i * (1 + i)^n) / ((1 + i)^n - 1))
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_P1A0i0n(A, i, n, disp)
'(P/A, i, n)
'P = A * (((1 + i)^n - 1) / (i * (1 + i)^n))

  If disp Then
    e_P1A0i0n = "P = A * (((1 + i)^n - 1) / (i * (1 + i)^n))"
  Else
    e_P1A0i0n = A * (((1 + i)^n - 1) / (i * (1 + i)^n))
  End If

End Function

'--- --- --- --- --- --- --- --- --- --- --- ---
'Continuous Compounding at Nominal Rate r : Single Payment
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_SinglePaymentF_Pern(P, e, r, n, disp)
'F = P* e^(r*n)

  If disp Then
    e_SinglePaymentF_Pern = "F = P* e^(r*n)"
  Else
    e_SinglePaymentF_Pern = P * exp(r * n)
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_SinglePaymentP_Fern(F, e, r, n, disp)
'P = F*e^(-r*n)

  If disp Then
    e_SinglePaymentP_Fern = "P = F * e^(-r*n)"
  Else
    e_SinglePaymentP_Fern = F * exp(-r*n)
  End If

End Function

'--- --- --- --- --- --- --- --- --- --- --- ---
'Continuous Compounding at Nominal Rate r : Uniform Series
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_UniformCompooundA1_Frn(F, r, n, disp)
'A = F * ((e^r - 1) / (e^r*n - 1))

  If disp Then
    e_UniformCompooundA1_Frn = "F * ((e^r - 1) / (e^r*n - 1))"
  Else
    e_UniformCompooundA1_Frn = F * ((exp(r) - 1) / (exp(r*n) - 1))
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_UniformCompoundA2_Prn(P, r, n, disp)
'A = P * ((e^(r*n) * (e^(r) - 1)) / (e^(r*n) - 1))

  If disp Then
    e_UniformCompoundA2_Prn = "A = P * ((e^(r*n) * (e^(r) - 1)) / (e^(r*n) - 1))"
  Else
    e_UniformCompoundA2_Prn = P * ((exp(r*n) * (exp(r) - 1)) / (exp(r*n) - 1))
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_UniformCompoundF_Arn(A, r, n, disp)
'F = A * ((e^(r*n) - 1) /  (e^(r) - 1))

  If disp Then
    e_UniformCompoundF_Arn = "F = A * ((e^(r*n) - 1) /  (e^(r) - 1))"
  Else
    e_UniformCompoundF_Arn =A * ((exp(r*n) - 1) /  (exp(r) - 1))
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_UniformCompoundP_Arn(A, r, n, disp)
'P = A * ((e^(r*n) - 1) / (e^(r*n) * (e^(r) - 1)))

  If disp Then
    e_UniformCompoundP_Arn = "P = A * ((e^(r*n) - 1) / (e^(r*n) * (e^(r) - 1)))"
  Else
    e_UniformCompoundP_Arn =  A * ((exp(r*n) - 1) / (exp(r*n) * (exp(r) - 1)))
  End If

End Function

'--- --- --- --- --- --- --- --- --- --- --- ---
' Continuous Uniform Cash Flow with Continuous Compounding : Present Worth Over Period n Per Year
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_P1F0r0n(F, r, n, disp)
'(P/F, r, n)
'P = F * ((e^(r)-1) / (r * e^(r*n)))
  If disp Then
    e_P1F0r0n = "P = F * ((e^(r)-1) / (r * e^(r*n)))"
  Else
    e_P1F0r0n = F * ((exp(r)-1) / (r * exp(r*n)))
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
' Continuous Uniform Cash Flow with Continuous Compounding : Compound Amount Over Period n Per Year
'--- --- --- --- --- --- --- --- --- --- --- ---
Function e_F1P0r0n(P, r, n, disp)
'(F/P, r, n)
'F = P * (( (e^(r) - 1) * (e^(r*n)) ) / (r*e^(r)))
  If disp Then
    e_F1P0r0n = "F = P * (( (e^(r) - 1) * (e^(r*n)) ) / (r*e^(r)))"
  Else
    e_F1P0r0n = P * (( (exp(r) - 1) * (exp(r*n)) ) / (r*exp(r)))
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
'Perpetual Annuity : Present Value
'--- --- --- --- --- --- --- --- --- --- --- ---

Function e_PerpetualAnnuity_Ar(A, r, disp)
'P = A/ r
  If disp Then
    e_PerpetualAnnuity_Ar = " P = A / r"
  Else
    e_PerpetualAnnuity_Ar = A / r
  End If

End Function
'--- --- --- --- --- --- --- --- --- --- --- ---
'Perpetual Annuity : Period Amount
'--- --- --- --- --- --- --- --- --- --- --- ---

Function e_PerpetualAnnuity_rP(r, P, disp)
'A = r * P
  If disp Then
    e_PerpetualAnnuity_rP = "A = r * P"
  Else
    e_PerpetualAnnuity_rP = r * P
  End If

End Function
