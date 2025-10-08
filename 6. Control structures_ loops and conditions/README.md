## Topic

In this session, we will discuss:

* 6. Control structures: loops and conditions
* 6.1 if, else and for
* 6.2 Vectorised code
* 6.3 Further Reading


## keywords & Notes

### 6. Control structures: loops and conditions

In this session, we learn how to make R think and repeat.

You’ll explore two important programming ideas:

  1. **Conditions** — making decisions in your code (for example, using `if` statements).

  2. **Loops** — repeating tasks automatically (for example, using `for` or `while` loops).

>[!NOTE]
> These tools help you control how your code runs, so you can tell R:
> * 👉 “If this happens, do that,” or
> * 👉 “Do this action several times.”

📘 To get started, read Chapter [13.1 and 13.2 from R Programming for Data Science](https://bookdown.org/rdpeng/rprogdatascience/control-structures.html).
They give a beginner-friendly introduction to how loops and conditions work in R.

* 13 Control Structures
* 13.1 if-else
* 13.2 for Loops
* 13.3 Nested for loops
* 13.4 while Loops
* 13.5 repeat Loops
* 13.6 next, break
* 13.7 Summary

#### 13 Control Structures
[Watch a video of this section](https://www.youtube.com/watch?v=BPNLjUDZ8_o)

Control structures in R let us control how and when code runs.

Instead of executing everything in order, we can tell R to make decisions or repeat actions based on certain conditions.

They bring logic into our code — allowing it to respond to inputs or data patterns.

Common control structures include:

 * `if / else` – test a condition and decide what to do.
 * `for` – repeat something a fixed number of times.
 * `while` – keep repeating as long as a condition is true.
 * `repeat` – run continuously until you manually stop it with `break`.
 * `break` – stop a loop early.
 * `next` – skip the current loop step and move to the next one.
 * `return` - exit the function
  
  

>[!NOTE]
> These are mostly used when writing `functions` or `longer scripts`, but it’s important to understand them early — they make your R programs dynamic and intelligent.

>[TIP]
> To clear all variables from your R environment (that is, remove everything currently stored in memory), you can use this simple command:

```
rm(list = ls())

```
> 💡 Explanation:
> * `ls()` → lists all the variable names currently in your environment
> * `rm()` → removes them
> * `list = ls()` → tells R to remove everything listed by ls()
> * rm(list = ls()) -This does not delete files from your computer — it only clears the variables from R’s active memory.

##### 13.1 if-else

[Watch a video of this section](https://www.youtube.com/watch?v=ZaBtJPYYGwg)

The `if–else` statement helps R make decisions — it checks a condition and decides what to do depending on whether that condition is `TRUE` or `FALSE`.

🪜 Basic if statement

If a condition is `true`, R runs the code inside the `{ }`.

If it’s `false`, R simply `skips` it.

```
x <- 5

if (x > 3) {
  print("x is greater than 3")
}

```

🟢 Output:

```
[1] "x is greater than 3"

```
> If `x` was less than or equal to 3, nothing would happen.

![Basic if statement flow chart](./images/if_statement.jpg)

🪜 `if` with `else`

If you want R to do something `else` when the condition is false, add an `else block`:

```
x <- 2

if (x > 3) {
  print("x is greater than 3")
} else {
  print("x is not greater than 3")
}


```

🟢 Output:

```
[1] "x is not greater than 3"

```
![![If - else statement flow chart](./images/if_statement.jpg)](./images/if_else.jpg)


🪜 Multiple Conditions (`else if`)

You can check more than one condition using `else if`:

```
x <- 5

if (x > 8) {
  print("x is big")
} else if (x > 3) {
  print("x is medium")
} else {
  print("x is small")
}
```

🟢 Output:

```
[1] "x is medium"

```

![![If - else if statement flow chart](./images/if_statement.jpg)](./images/if_else_if.jpg)

🧮 Example: Using random numbers

```
# Generate a random number between 0 and 10
x <- runif(1, 0, 10)

if (x > 3) {
  y <- 10
} else {
  y <- 0
}

print(c(x, y))

```
> Here,
> * If `x > 3`, then y becomes 10
> * Otherwise, `y` becomes `0`

You can also write this in a shorter form:

```
y <- if (x > 3) 10 else 0

```
> Both ways are correct — choose whichever is easier for you to read.

>[TIP]
> You can have multiple separate `if` statements if you want to check several unrelated conditions — they will all be tested individually:

```
if (x > 3) {
  print("x is greater than 3")
}

if (x < 8) {
  print("x is less than 8")
}

```
> [!TIP]
> Use `if`, `else if`, and `else` to make your code smart and responsive to data conditions.



