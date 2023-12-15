### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ a3d77714-9ac8-11ee-3f71-13c6a25fdaec
begin
	using PlutoUI
	using PlutoTeachingTools
end

# ╔═╡ b15ae606-616e-44a6-b597-9313072cf23b
using LabelledArrays

# ╔═╡ 0952f51b-b9c7-4dd8-b8e2-96d870061b20
using NLsolve

# ╔═╡ 6b519be3-d813-4d84-a288-af024dc41368
TableOfContents()

# ╔═╡ 8b88b085-f6ff-425b-b5e7-df4dd45448d4
md"""# Essential numerical tools and perturbation analysis  (2.a)

## Day 2: Perturbation Analysis

Pablo Winant


African Econometric Society Workshop 14/12/23
"""

# ╔═╡ 84e855c3-7b8b-4338-b955-d76967f6fef0
md"![](https://upload.wikimedia.org/wikipedia/commons/6/6f/Pendulum-no-text.gif)"

# ╔═╡ 8624c390-e9ac-4e44-b3ce-9b1b50ad5ab3
md"""When doing modeling (not only in econonomics), we often encounters nonlinear systems that have no closed form but a steady-state.

The solution then consists in characterizing the variables in a neighbourhood of the steady-state and solve for them using a *linear* approximation of the model.

The result is a *linear* approximation of the solution.
"""

# ╔═╡ 0b0f8d80-3691-4c51-90d0-91a6acd06b41
aside(tip(md"In principle, the same approach can be carried out for higher orders of approximation.") )

# ╔═╡ 280a030f-2dc9-4b19-96c7-208b30fb9ad1
md"""## Implicit Function Theorem

The perturbation approach is closely related to the Implicit Functions Theorem.

Assume we know the relation between two variables $x\in \mathbf{R}^n$ and $y\in \mathbf{R}^n$: $f(x,y)=0$.


Assume we know that a particular pair satisfies this relation $f(x_0, y_0)$.

Then, if $f^{\prime}_y(x_0, y_0)$ is invertible, it is possible to construct a local approximation of a function $\varphi$ such that $y=\varphi(x)$ at least in the vincinity of $x_0$.

In practice, one *applies* the method of unknown coefficients.

"""

# ╔═╡ 215247a7-0788-491c-9698-fc7d1328cfed
tip(md"Under suitable assumptions on $f$, the I.F.T. actually implies the *existence* of a such a function on a global definition space.")

# ╔═╡ 5f9d9c15-6ed0-422f-9ac1-b139ba4fc058
Foldable("unknown coefficients", md"""
In practice, we use the approach of unknown coefficients.
If we postulate that we have a Taylor expansion for $\varphi$ expressed around the value that is known $x_0,y_0$

$y = \varphi(x) = y_0 + y_1 (x - x_0) + o(x-x_0)$

Then we inject this expression in the relation $f(x,y)=0$ to get

$f( x_0 + (x-x_0) , y_0 + y_1 (x - x_0) + o(x-x_0)) = 0$

Which yields, using the rules of taylor series:

$f(x_0, y_0) + f^{\prime}_x (x-x_0) + f^{\prime}_y (y_1 (x - x_0) ) + o(x-x_0)$

Since the first term is 0, and the last one is negligible the coefficients in front of $(x- x_0)$ must sum to 0 and we obtain the unknown coefficient $y_1$ as:

$y_1 = -(f^{\prime}_y)^{-1}f^{\prime}_x$

""")

# ╔═╡ 2ab12025-1af1-4cf5-8ff3-131bb1b4c866
md"## Two very topical applications in (macro)-economics"

# ╔═╡ 1d8d49d5-1265-42fb-9001-1462d176b9d3
md"""### DSGE Model

The perturbation approach works so well it has spurred the development of a full class of models, the Dynamic Stochastic General Equilibrium Models (DSGE).

These models were able to include all elements from the New Keynesian synthesis and the availability of an *easy-to-use solution method*, made it possible to:

- incorporate new theories into the models
- interpret models predictions using impulse response functions
- estimate models using statistical tools

Nowadays all central banks have some form of DSGE model 
- Generally based on  *midsize model* from Smets & Wouters (10 equations)
    - (IMF/GIMF, EC/Quest, ECB/, NYFed/FRBNY)
- but have grown up a lot (>>100 equations)
- Institutions are (slowly) diversifying their model portfolios
    - CGEs
    - Agent-based
    - Semi-structural models (again)
    - Heterogenous Agents

"""

# ╔═╡ 7f9a215f-4511-4fb6-8f92-adef9243b430
aside(tip(md"""This [paper](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4531026) argues that a big determinant in the development of DSGE models is easy availability of modeling tools like Dynare."""))

# ╔═╡ a9e32f2c-a1ff-4fc2-b613-fc2f26a13191
md"""### Heterogeneous Agents Modeling

Nowadays there are lots of models featuring a continuous distribution of agents (firms, households, banks)

These models are fully nonlinear (possibly with kinks) when it comes to the idiosyncratic decision variables  of each agent.

But the dependence in aggregate shocks is highly non-tractable.

A common approach consists in:
- computing a fully-nonlinear stationary distributinon of agents (the steady-state)
- __perturbing it with respect to the aggregate shocks__

💡 Said perturbation has a lot in common with simple DSGEs
"""

# ╔═╡ 78a385d6-f18f-4784-8180-e74dfc00045f
md"""## DSGE Modeling
Dynare has popularized the following modeling approach:
- write a model:
  - equations
  - calibration of paramters
  - steady-state guess
- check that steady-state is correct
  - if not try to find one numerically
  - if no luck: go back to the model
- check that model is well-specified (Blanchard-Kahn)
  - if not: go back to modeling
- enjoy the simulations...
"""
	

# ╔═╡ 290082c3-19b6-4126-a804-433cc17101d8
(tip(md"""## Dynare

- an opensource tool to solve DSGE models
- a modelling language
- primary Matlab based but
  - Fortran, Gauss, in the past
  - versions in Octave
  - a WIP in Julia
"""))

# ╔═╡ 067c90bc-4cde-49ed-a9a7-4cd99ac20137
md"""## The RBC Model

The planner version:

- objective:
  $$\max_{\begin{matrix}c_t, n_t\\\\c_t \geq 0, y_t \geq c_t, n_t \geq 0, 1 \geq n_t\end{matrix}} \mathbb{E}_0 \left[ \sum \beta^t \left( \frac{c_t^{1-\sigma}}{1-\sigma} - \chi \frac{n_t^{\eta-1}}{\eta-1} \right) \right]$$


Under the following constraints:

- production:  $$q_t  = \exp(z_t) k_{t-1}^{\alpha} n_t^{1-\alpha}$$
- investment: $$i_t = q_t - c_t$$
- capital law of motion: $$k_t = (1-\delta) k_{t-1} + i_t$$
- productivity law of motion: $$z_t = (1-\rho) z_{t-1} + \epsilon_t$$

Where  $\epsilon_t$ is an i.i.d shock, normally distributed.

"""

# ╔═╡ a9741083-b463-4d87-82db-ce18f6a20108
md"""## RBC Model First Order Conditions

The maximization program yields the following first order conditions:

---
- optimal investment: $(c_t)^{-\gamma} = \beta \mathbb{E}_t \left[  (c_{t+1})^{-\gamma} \left( (1-\delta) + \alpha e^{z_{t+1}} {\color{red}k_{t}}^{\alpha-1} n_{t+1}^{1-\alpha} \right) \right]$
- optimal labour supply: $\chi n_t^\eta =  (1-\alpha) e^{z_t} {\color{red}k_{t-1}}^{\alpha} (n_t)^{-\alpha}  (c_t)^{-\gamma}$
- production:  $$q_t  = \exp(z_t) {\color{red}k_{t-1}}^{\alpha} n_t^{1-\alpha}$$
- investment: $$i_t = q_t - c_t$$
- capital law of motion: $$k_t = (1-\delta) {\color{red}k_{t-1}} + i_t$$
- productivity law of motion: $$z_t = (1-\rho) {\color{red}z_{t-1}}  + {\color{green}\epsilon_t}$$
---
Where  ${\color{green}\epsilon_t}$ is an i.i.d shock, normally distributed with standard deviation $\sigma$.
"""

# ╔═╡ cacc0065-3cc9-4253-a8e0-6ddd75fb7629
md""" ## Conventions
Note that in this set of equations we follow the dynare conventions:
- no distinction between states and controls:
    - __endogenous__ variables $k_t, y_t, n_t, i_t, z_t$
       - can appear at $t-1$, $t$, $t+1$
    - __exogenous__ variables $\epsilon_t$ at date $t$
- variables have subscript $t$ if they are first known at date $t$
  - New information arrives with the innovations $\epsilon_t$. 
  - i.e. information set is spanned by $\mathcal{F}_t = \mathcal{F} (\cdots, \epsilon_{t-3}, \epsilon_{t-2}, \epsilon_{t-1}, \epsilon_t)$
"""

# ╔═╡ dfd01a1d-b99d-4787-91c7-9d5b80716e08
warning_box(md"""
These conventions are different from ones typically used in optimal control. To check that your timing is correct, reason about which variables are *predetermined*.
For instance, when producing $y_t = k_{t-1}^{\alpha} n_{t}^{\alpha}$, the level of capital cannot be adjusted to the productivity innovation to produce in period $t$ hence it appears with date $t-1$.
""")

# ╔═╡ a0108971-2ad0-4d91-8e5c-5b0c2ed2a9a3
md"""## Abstract Representation

Denote by $y_t$ the vector of endogenous variables.
Denote by $e_t$ the vector exogenous variables.

The model can be represented by a function $f$ such that:

$$\forall t \; \mathbf{E}_t \left[ f(y_{t-1}, y_t, y_{t+1}, e_t)\right] =0$$

We look for a *recursive* solution $\varphi$ in the form $y_t = \varphi(y_{t-1}, e_t)$

"""


# ╔═╡ 8cdde359-7f3e-4069-ba65-44e5eb733744
tip(md"""In the RBC model we have:
- endogenous: $y_t = (k_t, q_t, n_t, i_t, z_t)$
- exogenous: $e_t = (\epsilon_t)$
- equations: each equation corresponds to a component of $f$\

*Remark*: expectations taken on variables at $t$ or $t-1$ can be ignored.
$E_t\left[k_t - (1-(1-\delta)k_{t-1}) - i_t\right]$ is simply $k_t - (1-(1-\delta)k_{t-1}) - i_t$
""")

# ╔═╡ ade8cbe9-b831-4159-a567-947b275bf6db
md"""## Steady-state

The *deterministic* steady-state is a value of endogenous variables, which solve the equations with $y_{t-1}=y_t=y_{t-1}$ an in the absence of shock (i.e. $e_t=0$).

It satisfies 

$f(\overline{y},\overline{y}, \overline{y}, 0) = 0$
"""

# ╔═╡ 915f7b62-e575-4a09-aed8-56b156d787df
tip(md"""For the RBC model, the steady-state can be computed as:

$$\begin{aligned}
    n = 0.33 \\
    z =  0 \\ 
    r_k = 1/\beta-1+\delta \\
    w =  (1-\alpha)*exp(z)*(k/n)^{\alpha} \\ 
    k = n/(r_k \ \alpha)^\left(1/(1-\alpha)\right) \\
    q =  exp(z)*k^\alpha*n^{1-\alpha} \\
    i = \delta*k \\
    c = q - i \\
\end{aligned}$$

which implies $\chi=w/c^\sigma/n^\eta$

""")

# ╔═╡ 1f1ae9b9-0b46-4002-af09-b1bc051d614f
md"""## Coding the RBC Model
Let's code it up
"""

# ╔═╡ 31dd27a9-63e5-4723-a01c-9175e8aea967
md"""First we need to provide __the calibration values and the steady-state__ values.

In the case of the RBC, it is easier to do both at once.
"""

# ╔═╡ b842fb46-47bf-43a8-bc57-c1f491ef1c7e
# parameters
#p = (;...)

# ╔═╡ 60216edb-78e4-4cb3-9722-b4eaee4cf1d7
md"__Then we define a function representing the model equations__"

# ╔═╡ eb832287-f2c6-48bc-b759-d94a4fbd571b
# LabelledVectors are useful here:
# - they behave like namedtuples, and like vectors

# ╔═╡ 0cdb19f2-2486-4b43-9323-a5adb87804c6
function f(v_f, v, v_p, e, p)
	
end

# ╔═╡ 5c17966d-3912-46a0-b06e-4d5ee2725516
md"""
__Check that the steady-state conditions are indeed met.__
"""

# ╔═╡ 93895ec9-1df7-4a85-91ba-0db6a3de19c9
# if they are not, change initial guess and/or model

# ╔═╡ 04fe8604-dad8-4356-b1ab-c27d0b0d3b79
md"__If the steady-state is not right, but you are sure about the model, you can also look for the steady-state numerically.__"

# ╔═╡ 8addfc8d-69b1-41be-91e7-b0573804b110


# ╔═╡ a3722be0-89a6-4565-ba23-8505b4f70002
md"""## Differentiating the Model

To solve the model, we we replace it by a first order approximation. To do so we replace

$$\mathbf{E}_t \left[ f(y_{t+1}, y_t, y_{t-1}, e_t)\right] =0$$

where the solution is: $y_t = \varphi(y_{t-1}, e_t)$

by 

$$\mathbf{E}_t\left[ A \hat{y}_{t+1} +  B \hat{y}_t + C \hat{y}_{t-1} + D e_t \right] = 0$$

where

- variable $\hat{y}=y_t-\overline{y}$ is in deviation to the steady-state
- solution is approximated by $\hat{y} = G_y \hat{y}_{t-1} + G_e e_t$
    - i.e. $y_t \approx \overline{y} + G_y \hat{y}_{t-1} + G_e e_t$
"""

# ╔═╡ 46b495b1-5e52-4992-98c6-8b5d11d53d29
md"""## The next steps

We still need to:

- compute:
$A = f^{\prime}_{y_{t+1}}(\overline{y},\overline{y},\overline{y}, 0)$
$B = f^{\prime}_{y_{t}}(\overline{y},\overline{y},\overline{y}, 0)$
$C = f^{\prime}_{y_{t-1}}(\overline{y},\overline{y},\overline{y}, 0)$
$D = f^{\prime}_{e_{t}}(\overline{y},\overline{y},\overline{y}, 0)$

- solve the equation in $G_y, G_e$

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LabelledArrays = "2ee39098-c373-598a-b85f-a56591580800"
NLsolve = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
LabelledArrays = "~1.15.0"
NLsolve = "~4.5.1"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "09fef13e9b09fde9ae92f60de99cc72fcc282ac0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cde29ddf7e5726c9fb511f340244ea3481267608"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "247efbccf92448be332d154d6ca56b9fcdd93c31"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.6.1"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "e0af648f0692ec1691b5d094b8724ba1346281cf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.18.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

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

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "886826d76ea9e72b35fcd000e535588f7b60f21d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "c6e4a1fbe73b31a3dea94b1da449503b8830c306"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.21.1"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

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

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

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

[[deps.LabelledArrays]]
deps = ["ArrayInterface", "ChainRulesCore", "ForwardDiff", "LinearAlgebra", "MacroTools", "PreallocationTools", "RecursiveArrayTools", "StaticArrays"]
git-tree-sha1 = "f12f2225c999886b69273f84713d1b9cb66faace"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.15.0"

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

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

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

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

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

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff", "Requires"]
git-tree-sha1 = "01ac95fca7daabe77a9cb705862bd87016af9ddb"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.13"

    [deps.PreallocationTools.extensions]
    PreallocationToolsReverseDiffExt = "ReverseDiff"

    [deps.PreallocationTools.weakdeps]
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

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

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "Requires", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "3f40e61c93a7c46b85df57b770bc360988f9ca36"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "3.0.0"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

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

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "5ef59aea6f18c25168842bded46b16662141ab87"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.7.0"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.SymbolicIndexingInterface]]
git-tree-sha1 = "65f4ed0f9e3125e0836df12c231cea3dd98bb165"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

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
# ╟─a3d77714-9ac8-11ee-3f71-13c6a25fdaec
# ╟─6b519be3-d813-4d84-a288-af024dc41368
# ╟─8b88b085-f6ff-425b-b5e7-df4dd45448d4
# ╟─84e855c3-7b8b-4338-b955-d76967f6fef0
# ╟─8624c390-e9ac-4e44-b3ce-9b1b50ad5ab3
# ╟─0b0f8d80-3691-4c51-90d0-91a6acd06b41
# ╟─280a030f-2dc9-4b19-96c7-208b30fb9ad1
# ╟─215247a7-0788-491c-9698-fc7d1328cfed
# ╟─5f9d9c15-6ed0-422f-9ac1-b139ba4fc058
# ╟─2ab12025-1af1-4cf5-8ff3-131bb1b4c866
# ╟─1d8d49d5-1265-42fb-9001-1462d176b9d3
# ╟─7f9a215f-4511-4fb6-8f92-adef9243b430
# ╟─a9e32f2c-a1ff-4fc2-b613-fc2f26a13191
# ╟─78a385d6-f18f-4784-8180-e74dfc00045f
# ╟─290082c3-19b6-4126-a804-433cc17101d8
# ╟─067c90bc-4cde-49ed-a9a7-4cd99ac20137
# ╟─a9741083-b463-4d87-82db-ce18f6a20108
# ╟─cacc0065-3cc9-4253-a8e0-6ddd75fb7629
# ╟─dfd01a1d-b99d-4787-91c7-9d5b80716e08
# ╟─a0108971-2ad0-4d91-8e5c-5b0c2ed2a9a3
# ╟─8cdde359-7f3e-4069-ba65-44e5eb733744
# ╟─ade8cbe9-b831-4159-a567-947b275bf6db
# ╟─915f7b62-e575-4a09-aed8-56b156d787df
# ╟─1f1ae9b9-0b46-4002-af09-b1bc051d614f
# ╠═b15ae606-616e-44a6-b597-9313072cf23b
# ╟─31dd27a9-63e5-4723-a01c-9175e8aea967
# ╠═b842fb46-47bf-43a8-bc57-c1f491ef1c7e
# ╟─60216edb-78e4-4cb3-9722-b4eaee4cf1d7
# ╠═eb832287-f2c6-48bc-b759-d94a4fbd571b
# ╠═0cdb19f2-2486-4b43-9323-a5adb87804c6
# ╟─5c17966d-3912-46a0-b06e-4d5ee2725516
# ╠═93895ec9-1df7-4a85-91ba-0db6a3de19c9
# ╟─04fe8604-dad8-4356-b1ab-c27d0b0d3b79
# ╠═0952f51b-b9c7-4dd8-b8e2-96d870061b20
# ╠═8addfc8d-69b1-41be-91e7-b0573804b110
# ╟─a3722be0-89a6-4565-ba23-8505b4f70002
# ╠═46b495b1-5e52-4992-98c6-8b5d11d53d29
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
