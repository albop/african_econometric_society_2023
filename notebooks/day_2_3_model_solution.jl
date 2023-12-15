### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 65cbab69-76de-4be8-8247-f5741a741239
begin
	using PlutoUI
	using PlutoTeachingTools
end

# ╔═╡ d175396b-93b2-4a7e-b11f-a56d501b472b
TableOfContents()

# ╔═╡ 918cfcf1-6680-46e9-8b29-3be78d3f4a24
md"""# Essential numerical tools and perturbation analysis  (2.a)

## Day 2: Solving the Model

Pablo Winant


African Econometric Society Workshop 14/12/23
"""

# ╔═╡ 0eb696e2-9aeb-11ee-3ecf-13a2dfa4319c
md"""## The Linear Model

Now we want to solve the linear model (we drop the hats):

$$E_t \left[ A {y}_{t+1} +  B {y}_t + C {y}_{t-1} + D e_t \right]= 0$$

where the *recursive* solution is 

${y_t} = G_y {y}_{t-1} + G_e e_t$

If $y_t \in \mathbf{R}^n$ and $e_t \in \mathbf{R}^{n_e}$ then:
- $A,B,C, G_y \in  \mathbf{R}^n \times  \mathbf{R}^n$ 
- $D, G_e\in \mathbf{R}^n \times \mathbf{R}^{n_e}$

"""

# ╔═╡ 12292eae-57a7-4cdd-ad92-682d00793adc
md"""## The Problem

Note that if the decision rule satisfies:
${y}_t = G_y {y}_{t-1} + G_e e_t$

we have 

$y_{t+1} = G_y {y}_{t} + G_e e_{t+1} = G_e e_{t+1} + G_y G_e e_t + G_y G_y y_{t-1}$

and if we make all substitutions in $E_t \left[ A {y}_{t+1} +  B {y}_t + C {y}_{t-1} + D e_t \right]$, we get:

$$\left( A G_y G_y  + B G_y + C \right) y_{t-1} + \left( A G_y G_e + B G_e + D G_e \right) e_t= 0$$

This must be true for any $y_{t-1}$ or $e_t$. This yields the conditions that define $G_y$ and $G_e$

$$A G_y^2 + B G_y + C$$
$$A G_y G_e + B G_e + D$$

"""

# ╔═╡ adcdae70-1b99-4739-9b91-02afcb98c58f
md"""## The Riccatti Equation

The transition matix $G_e$ must satisfy a *second order matrix equation*:

$$A X^2 + BX + C$$

From our intuition in dimension 1, we know there must be multiple solutions

- how do we find them?
- how do we select the right ones?

Obviously, the qualitative dynamics of the model are given by $y_t=X y_{t−1}$

For the solution to the model to be stationary, the spectral radius of X
 should be smaller than 1.

"""

# ╔═╡ 9e562831-6818-4385-a727-382b31f0fc64
md"""## The State-Space System

It is possible to associate a *linear* system to this Riccatti equation.

It is the *state-space* representation. It characterizes vectors $v_t = (y_t, y_{t+1})$ along any admissible trajectory. These vectors must satisfy:

$$\underbrace{\begin{bmatrix}  
I & 0 \\ 0 & A 
\end{bmatrix} }_{F} v_{t+1}
= \underbrace{\begin{bmatrix}  
0 & I \\ -C & -B
\end{bmatrix}}_{G} v_t$$

In particular, we are interested in *fundamental* trajectories, such that
$\mu v_{t+1} = \lambda v_t$ where $\mu, \lambda \in \mathbf{R}$.

"""

# ╔═╡ c25fc7c9-519f-4368-834f-48e3f264e142
warning_box(md"""The formulation with a pair of generalized eigenvalues $\mu$, $\lambda$ is just a technicality meant to avoid infinite eigenvalues in the calculations which can happen when $A$ is defective.
To build the intuition, it is suggested to look at the case $\mu=1$ and $A=I$.""")

# ╔═╡ e8b33659-a962-4e7b-bbd0-a751a16125f8
md"""Note that, on a fundamental trajectory, we have $\mu (y_t, y_{t+1}) = \lambda (y_{t-1}, y_t)$.

These trajectories are clearly recursive:  $y_t=\frac{\lambda}{\mu} y_{t-1}$ 

When $\mu=0$ and $\lambda\neq 0$ we say there is an infinite eigenvalue. Most of the theory works if we forget about $\mu$ but consider only $\lambda \in [0,\infty]$
"""


# ╔═╡ 86ab3b74-183b-433c-9caf-f96496e2977d
md"""## The eigenvalues of the system

According to generalized eigenvalue theory, the system has generically $2 n$ fundamental trajectories: $(\mu_1, \lambda_1, v_1), ... (\mu_{2n}, \lambda_{2n}, v_{2n})$

To simplify our reasoning we can assume that eigenvalues are ranked in increasing eigenvalues (with infinite eigenvalues last):

$0 |\lambda_1| \leq ... \leq |\lambda_{2n}| \leq \infty$

Remember that fundamental trajectories are recursive?

It can be shown that any recursive solution $X$ to the quadratic system is obtained, by selecting $n$ different eigenvectors.

As a result, there are exactly $\left(\begin{matrix} 2n \\ n\end{matrix}\right)$ different solutions to our system.

The model is __well defined__ when only 1 of all this solutions is non divergent. This is equivalent to say:

$0 \leq |\lambda_1| \leq ... \leq \lambda_n \leq 1 < |\lambda_{n+1}| \leq ... \leq |\lambda_{2n}| \leq \infty$


"""

# ╔═╡ 9e6e97eb-32fc-4942-99c8-bba65d05a3ee
md"""## Example 1

Forward looking inflation:

$$\pi_t = \alpha \pi_{t+1}$$
with $\alpha>1$. Is it well defined?

---

We can rewrite the system as:
$$\alpha \pi_{t+1} - \pi_t + 0 \pi_{t-1} = \pi_{t+1} - (\frac{1}{\alpha} + 0 )\pi_t + \left(\frac{1}{\alpha} 0\right) \pi_{t-1}$$

The eigenvalues are $0\leq 1 < \frac{1}{\alpha}$.
The unique solution is $\pi_t=0 \pi_{t-1}$

"""

# ╔═╡ fa74f188-507d-4194-8596-f974404a30b8
md"""## Example 2

Debt accumulation equation by a rational agent:

$$b_{t+1} - (1+\frac{1}{\beta}) b_t + \frac{1}{\beta} b_{t-1} = 0$$

Is it well-defined? 

The associated polynomial $x^2 - (1+\frac{1}{\beta}) x + \frac{1}{\beta}$ has two eigenvalues $\lambda_1=1 < \lambda_2=\frac{1}{\beta}$

The unique solution is $b_t = b_{t-1}$.

- it is a *unit-root*: any initial deviation in $b_{t-1}$ has persistent effects

"""

# ╔═╡ 31887c05-8051-4ef7-8f9d-333908dee014
md"""## Example 3

Productivity process: 
$$z_t = \rho z_{t-1}$$
with $\rho<1$

---

The generalized eigenvalues are $\lambda_1 = \rho \leq 1 < \lambda_2 = \infty$

More generally, any variable that does not appear in $t+1$ creates one infinite generalized eigenvalue.

"""

# ╔═╡ e8f6754b-071e-4de4-b09b-bff481a1c25f
tip(md"""
To see where the hidden eigenvalue comes from: make $\lambda\rightarrow \infty$ in the following equation:

$$z_{t+1} - (\lambda+\rho) z_t + \frac{\lambda}{\rho} z_{t-1} = 0$$
""")


# ╔═╡ 944b3131-7f19-46a3-931f-8e34c2a5987a
md"""## Blanchard-Kahn Criterium

Remember the criterium for well-definedness?

$0 |\lambda_1| \leq ... \leq \lambda_n \leq 1 < |\lambda_{n+1}| \leq ... \leq |\lambda_{2n}| \leq \infty$

Now realize (or admit) that for each variable not appearing in $t+1$  in the model, there is an associated infinite eigenvalue.

We can deduce from that a common formulation of the Blanchard-Kahn criterium:
"""

# ╔═╡ 329de2e3-c262-4906-b941-22492e04bdf8
blockquote(md"The model satisfies the Blanchard-Kahn criterium if the number of eigenvalues greater than one, is exactly equal to the number of variables *appearing* in $t+1$.")

# ╔═╡ dcc6b50d-8948-45ff-ae80-1500e9a2c2b5
md"""It is equivalent to the __existence and unicity of a non-divergent recursive solution.__"""

# ╔═╡ ab73f8a9-8850-426b-b662-80cdc55f5080
md"""## Computing the solution

There are several classical methods to compute the solution to the algebraic Riccatti equation: $$A X^2+ B X + C=0$$

- qz decomposition
    - traditionnally used in the DSGE literature
    - a little bit unintuitive but easy to implement from the state-space representation
    - constructive: it produces *all* eigenvalues which makes it easy to check BK conditions
- cyclic reduction
    - more adequate for big models
- linear time iteration
    - very easy to remember/implement
"""

# ╔═╡ 443d6374-f3cc-4e85-8440-e5d97c622ef7
md"""## Checking the solution

Cyclic Reduction and Linear Iteration are iterative algorithms that usually converge to a solution $X$ but sometimes fail to do so.

After using one of these algorithms we can check
- that the solution is non divergent:
$$\rho(X)<1$$
- check that the first rejected eigenvalue is smaller than 1:
$$\rho( (A X + B)^{-1} A )<1$$
"""

# ╔═╡ 8e407d2f-f9d3-4269-b249-61438d315685
tip(md"""Using solvant theory, it is possible to show that the eigenvalues of $(A X + B)^{-1} A$ are precisely the inverse of all the eigenvalues that have been rejected while constructing $X$""")

# ╔═╡ 6de29eb2-5bbb-4d4b-831d-d619294bb03a
md"""
## Linear Time Iteration (1)

Return to the Ricatti system but suppose that decision rules today and tomorrow are different:

- today: $y_t = \overline{y} + X y_{t-1} + G_y e_t$
- tomorrow: $y_{t+1}  = \overline{y} + \tilde{X} y_{t-1} + G_y e_t$

Then the Ricatti equation becomes:

$$A \tilde{X} X + B X + C = 0$$
"""

# ╔═╡ 7c5662ff-5e34-49e7-be3f-058c30245041
md"""
## Linear Time Iteration (2)

The linear time iteration algorithm consists in solving the decision rule $X$  today as a function of decision rule tomorrow $\tilde{X}$.
This corresponds to the simple formula:

$$X = -(A\tilde{X} + B)^{-1} C$$

And the full algorithm can be described as:

- choose $X_0$
- for any $X_n$, compute $X_{n+1} = T(X_n) = -(A X_n + B)^{-1} C$
    - repeat until convergence

"""

# ╔═╡ 92b555c4-eb32-46d7-b927-1a0c0776fdf0
tip(md"Linear Time Iteration is a special case of a Bernouilli iteration")

# ╔═╡ 86d66bce-c75e-4b39-a1f8-6348dd1ed77c
md"""
## Linear Time Iteration (3)

Starting from a random initial guess, the linear time-iteration algorithm usually converges to the solution $X$ with the smallest modulus:

$$\underbrace{|\lambda_1| \leq \cdots  \leq |\lambda_n|}_{\text{Selected eigenvalues}} \leq |\lambda_{n+1}|\cdots \leq |\lambda_{2n}|$$

In other words, it finds the right solution when the model is well specified.

Then you just need to check that first rejected eigenvalue is greater than 1.
"""

# ╔═╡ b4dbae36-9a24-4990-8111-2eb0d5b4e150
warning_box(md"In some cases, there is no convergence. For instance if $|\lambda_n|=|\lambda_{n+1}|$). Or for a specific initial value $X_0$ such that some $A X_n + B$ is not invertible. However when the algorithm converges, it always satisfies the above condition.")

# ╔═╡ 0a42ac8b-f645-4af2-a1e8-844bca21a776
md"""## Exercise

Finish the solution of the RBC model.
"""

# ╔═╡ cacc1b03-ea74-4971-80ae-73aa85361587
md"""__Copy and paste the code for the model from session 1.__"""

# ╔═╡ f691edf2-d50f-4382-bd07-f64cf93c1bd8


# ╔═╡ 4ef04627-26bb-4c4f-a4b6-90b6f7282c78
md"""__Use ForwardDiff to compute A,B,C,D__"""

# ╔═╡ b2cb4ee4-abb8-4745-902e-7cf4358b458f


# ╔═╡ 7abed858-2c77-439e-8e2f-871e882d08b9
md"""__Implement the time-iteration algorithm to solve for $G_y$__"""

# ╔═╡ 1900f18d-da64-4375-a541-0cd7fea65dc4


# ╔═╡ b2bf2912-0325-4bcc-b30a-dbc6fe862c68
md"__Check that the solution solves the original problem__"

# ╔═╡ e05565d0-8efa-4110-9af6-5b421629a2d2


# ╔═╡ d9d8dcdf-fec5-4a18-bc5c-a0c6a5b7fe48
md"__Check that the greatest eigenvalue of the solution is smaller than 1__"

# ╔═╡ 485c9a36-178b-4e6e-a290-76c26717a9a2


# ╔═╡ f048ed01-faa3-45d0-9873-243a58221599
md"__Check that the first excluded eigenvalue is greater than 1.__"

# ╔═╡ 81d596cd-6f45-4ab4-98b7-9b4e252b6254
md"__Compute $G_e$__"

# ╔═╡ 50e28341-1356-470a-b86b-311c778763d0


# ╔═╡ 0038b8da-6c4a-493e-a5ce-dfa661fd05eb
md"__Bonus: compute the generalized eigenvalues of state-space system. Are they consistent with what you have found?__"

# ╔═╡ 5eeccd7d-b837-471c-8c31-92d5a0c7f7c2


# ╔═╡ 5cbe03b5-e1cb-4ee5-bd9b-bd78e0958150
md"""__Bonus: plot some impulse response functions.__"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "fed425e8e2f90548e58e6c0e08c0776b19adcca2"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "e49bce680c109bc86e3e75ebcb15040d6ad9e1d3"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.27"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "0b8cf121228f7dae022700c1c11ac1f04122f384"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.2"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "6990168abf3fe9a6e34ebb0e05aaaddf6572189e"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.10"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─65cbab69-76de-4be8-8247-f5741a741239
# ╟─d175396b-93b2-4a7e-b11f-a56d501b472b
# ╟─918cfcf1-6680-46e9-8b29-3be78d3f4a24
# ╟─0eb696e2-9aeb-11ee-3ecf-13a2dfa4319c
# ╟─12292eae-57a7-4cdd-ad92-682d00793adc
# ╟─adcdae70-1b99-4739-9b91-02afcb98c58f
# ╟─9e562831-6818-4385-a727-382b31f0fc64
# ╟─c25fc7c9-519f-4368-834f-48e3f264e142
# ╟─e8b33659-a962-4e7b-bbd0-a751a16125f8
# ╟─86ab3b74-183b-433c-9caf-f96496e2977d
# ╟─9e6e97eb-32fc-4942-99c8-bba65d05a3ee
# ╟─fa74f188-507d-4194-8596-f974404a30b8
# ╟─31887c05-8051-4ef7-8f9d-333908dee014
# ╟─e8f6754b-071e-4de4-b09b-bff481a1c25f
# ╟─944b3131-7f19-46a3-931f-8e34c2a5987a
# ╟─329de2e3-c262-4906-b941-22492e04bdf8
# ╟─dcc6b50d-8948-45ff-ae80-1500e9a2c2b5
# ╟─ab73f8a9-8850-426b-b662-80cdc55f5080
# ╠═443d6374-f3cc-4e85-8440-e5d97c622ef7
# ╠═8e407d2f-f9d3-4269-b249-61438d315685
# ╟─6de29eb2-5bbb-4d4b-831d-d619294bb03a
# ╟─7c5662ff-5e34-49e7-be3f-058c30245041
# ╟─92b555c4-eb32-46d7-b927-1a0c0776fdf0
# ╟─86d66bce-c75e-4b39-a1f8-6348dd1ed77c
# ╟─b4dbae36-9a24-4990-8111-2eb0d5b4e150
# ╟─0a42ac8b-f645-4af2-a1e8-844bca21a776
# ╠═cacc1b03-ea74-4971-80ae-73aa85361587
# ╠═f691edf2-d50f-4382-bd07-f64cf93c1bd8
# ╠═4ef04627-26bb-4c4f-a4b6-90b6f7282c78
# ╠═b2cb4ee4-abb8-4745-902e-7cf4358b458f
# ╠═7abed858-2c77-439e-8e2f-871e882d08b9
# ╠═1900f18d-da64-4375-a541-0cd7fea65dc4
# ╠═b2bf2912-0325-4bcc-b30a-dbc6fe862c68
# ╠═e05565d0-8efa-4110-9af6-5b421629a2d2
# ╠═d9d8dcdf-fec5-4a18-bc5c-a0c6a5b7fe48
# ╠═485c9a36-178b-4e6e-a290-76c26717a9a2
# ╠═f048ed01-faa3-45d0-9873-243a58221599
# ╠═81d596cd-6f45-4ab4-98b7-9b4e252b6254
# ╠═50e28341-1356-470a-b86b-311c778763d0
# ╠═0038b8da-6c4a-493e-a5ce-dfa661fd05eb
# ╠═5eeccd7d-b837-471c-8c31-92d5a0c7f7c2
# ╠═5cbe03b5-e1cb-4ee5-bd9b-bd78e0958150
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
