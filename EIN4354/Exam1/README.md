# Engineering-Economy
Getting shit done

## Function Syntax
Please put functions in the following example syntax:

Formula:
F = P(1+r)^n
Formula ID:
(F/P,i,n)

    Function F1P0i0n(P, i, n, disp)
    
        If disp Then
            F1P0i0n = "F = P(1+r)^n"
        Else
            F1P0i0n = P * (1 + r) ^ n
        End If

    End Function

### Naming
Take ID of a formula. (See example).
Replace commas with 0s.
Replace slashes with 1s.

### Standards
Always have a 'disp' arg. If true, set function return to a string representation of the formula. If false, solve for the given inputs.

No one remembers the quiz questions like you Michelle -_-