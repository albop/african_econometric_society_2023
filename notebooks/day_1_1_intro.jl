### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 340c206c-edcc-4510-9828-ec7a69ba471e
using Bits

# ╔═╡ a40c20dc-0473-4b14-b229-c2416f43422d
begin
	using PlutoUI
	using PlutoTeachingTools
end

# ╔═╡ 28618afa-99f6-11ee-102b-49f1a1b27f4a
md"""# Essential numerical tools and perturbation analysis  (1.a)

## Introduction

Pablo Winant


African Econometric Society Workshop 14/12/23
"""

# ╔═╡ 753379cc-d977-4ce9-9ded-b4699601046a
md"""
## About me
"""

# ╔═╡ 550e6844-efaf-48a8-91f8-c27d40b7e3c3
TwoColumn(
	md"![Pablo Winant](https://www.mosphere.fr/tie/0_girafes.jpg)",
	md"""
- A computational economist
- Formerly Worked in institutions (IMF, BOE)
- Now at ESCP Business School and CREST/Polytechnique
- Research on models about:
  - Inequality (heterogeneity)
  - International Finance
  - Monetary Policy
  - Artificial Intelligence
- Involved in several opensource projects (Dolo, QuantEcon, ARK)
"""
)

# ╔═╡ 4a5d8ba0-dcc7-4ef3-9ebb-c8fad4a2b4eb
md"""
## About this course
"""


# ╔═╡ ce753fef-a72a-4546-a8dd-1bcb490777df
TwoColumn(md"""
Day 1:

- intro to Julia
- recursive sequences
- function optimization
- 👉 static equilibrium models

""", md"""
Day 2:
- (dynamic) first order conditions
- automatic differentiation
- solution of matrix quadratic equations
- 👉 dynamic stochastic equilibrium models

""")

# ╔═╡ 9ab5c25e-206c-4bdf-ad3f-6e237ab32814
md"""Complements the course given by Jesus Fernandez Villaverde."""


# ╔═╡ ae2bf128-f87e-4b59-a3b1-a71de9a72bbc
md"""
## About Our Work Environment Today

- We will use Julia:
  - a language, specifically designed for numerical science
- We use [Pluto.jl](https://github.com/fonsp/Pluto.jl) on JuliaHub
- Two commands:
  - Shift+Enter: run a cell
  - Ctrl+Enter: run a cell and create a new one
     - for mac: Ctrl replaced by Cmd


"""

# ╔═╡ 7dffaab1-b630-43e3-b33a-e6fe83d3c6da
3 + 9

# ╔═╡ 605859a4-af1c-48dd-a174-14e77b56ff81
md"""
## About the Future

There is a variety of (free!) environments to program in Julia

- the console
- JupyterLab
- Visual Studio Code
"""

# ╔═╡ 0169f5f3-fe98-45c3-a945-026b24e31e26
tip(md"""
To install Julia, instead of downloading the regular package, lookup [juliaup](https://github.com/JuliaLang/juliaup). You get one single command to install a Julia multiplexer which can handle many Julia versions at once.
""")

# ╔═╡ 064ddccb-7679-4dc7-a443-d784e54947d0
md"""
## About Julia

Why [Julia](https://julialang.org/)?
- it is opensource. There are *hundreds* of libraries
- syntax inspired by Matlab but:
    - more consistent
    - much better!
- it is Just in Time (JIT) compiled
  - one can quickly experiment with code like an interpreted language
  - code gets translated using LLVM to run at machine speed
- there is a vibrant community with tons of online resources
- you can start easy and progressively get full control
"""

# ╔═╡ 28df9d8a-eea7-4d43-8def-58ab0221a61e
[n^2 for n in 1:100 if mod(n,2)==0 ]

# ╔═╡ 1750789d-d2f1-45d7-a3ff-554e061efade
md"""## An example of what not to do in Matlab
"""

# ╔═╡ ad4ba04b-83b1-4394-a3d6-0429b4693129
function stupid_loop(I,J,K)
    t = 0.0
    for i=1:I
        for j=1:J
            for k = 1:K
                t += 1.0
            end        
        end
    end
    return t
end

# ╔═╡ 2b045036-f24c-4fc6-8e89-06c3d3ee0cca
@time stupid_loop(1000,1000,1000)

# ╔═╡ 35cdd77b-66bc-49a7-89c0-acc7f4cb570c
@code_llvm stupid_loop(10,10,10)

# ╔═╡ 19f6a557-00fc-4a26-b828-aa843df67024
@code_native stupid_loop(10,10,10)

# ╔═╡ c2320d66-897a-46d7-97f6-020f9271dd05
md"## Your Journey with Julia
"

# ╔═╡ 7c24504b-040d-4a5b-acce-b972b8330e5f
ThreeColumn(md"""
stage 1:
- basic types (numbers, strings)
- define functions
- use macros
- enjoy syntactic sugar
""",
md"""
stage 2: 
- experiment with many libraries
- write type-stable code
- define own types
- use multiple dispatch
	
""",
md"""
stage 3:
- metaprogramming
- avoid memory allocations
- ...
"""
)

# ╔═╡ 0014eaac-8106-4357-b27e-69ba81d10ae1
md"""
## First discoveries
"""


# ╔═╡ 49a15cab-0eda-4abb-9fe5-b166d070fe7b
md"""
### Basic Types
The following code assigns a number to a variable.
Change the variable so that it contains: a float (64 bits), an integer, a float 32, a boolean (true or false)
"""

# ╔═╡ d25e5c35-b828-414f-a8a9-3b65de626464
a = Float32(2)

# ╔═╡ 51887f62-310c-44d8-a2a2-57ad0072a56c
typeof(a)

# ╔═╡ decd77fe-d205-4f9b-8c96-35c865faf6b5
sizeof(a) # the answer is given in bytes (i.e. 8 bits on most computers)

# ╔═╡ 43c15289-e95e-4d45-8416-44b0617297ca
factorial(BigInt(500))

# ╔═╡ 4dafa1c3-bca1-467a-9cba-ae9624d1b6d8
bits(a)

# ╔═╡ 71a3ac4a-7393-48dc-a174-6e256e1a06c1
md"""
### Operations on Numbers

No big suprise
"""

# ╔═╡ 011f4cfc-8586-4737-ab4e-3a61c47dc39e
2 + 3 # try with +, -, *, /, ^

# ╔═╡ 53e05778-b13a-40b7-a2e0-f6a5bf0f26c3
2 + 3.0 # conversion to the most precise type

# ╔═╡ dd652d05-4837-4ca8-8109-bac0485d7fa6
2/5 # division returns a float

# ╔═╡ 4d889960-c823-4be2-84da-07a7a517af44
5%2

# ╔═╡ 0b9a5da1-bfcc-4797-8372-ea859faabb61
2//5 + 1//3 # fraction

# ╔═╡ c6cd1035-acae-468c-8f37-0ec42cd1af8b
3^3

# ╔═╡ 2d5dcd90-6619-41d6-8900-50b1de500484
md"""
### Strings (1)

There are several ways to define a string: "... " for regular strings, for multiline \"\"\" ...\"\"\".

Strings can be manipulated as objects and "printed" to the terminal using function `println()`

"""

# ╔═╡ dcedd483-eb89-4e43-8dd2-e7a2ba2bf354
aside(warning_box(md"In Julia quotes are used to denote a single character as in 'α'") )

# ╔═╡ ab5e8fd2-87a4-4657-9ae5-1093639a514b
txt1 = "This is a regular string. New lines must be signalled with the \\n special charachter.\nThe string continues.\nIf you wish to use an anteslash in the string, you need to 'escape' it with another anteslash: \\"

# ╔═╡ 4468a778-9b2a-468c-98ae-26a16916d12f
# print string txt1
println(txt1)

# ╔═╡ 6b600525-6ce4-40ce-ad26-6fecafa9bbac
txt2 = """
In a multiline string, the first newline is ignored, 
Words flow together, in syntax they're deployed.
Yet in this silent space, a tale can be enjoyed,
As lines of code and verse are cleverly employed.
"""

# ╔═╡ 2451a56f-d9a0-4493-a2e1-fa4c9758215d
# print string txt2
println(txt2)

# ╔═╡ b82920bc-4309-4c73-b348-589ae810af93
md"""
### Strings (2)

Strings can contain any unicode character including many alphabets and emoticons.
To interpolate a value inside a string we use the dollar sign '\$'.
"""

# ╔═╡ 40b2b811-de3d-4533-84d5-60297274f4ee
tip(md"""Like in Jupyter notebooks, greek letters can be entered by typing their latex representation and hitting Tab""")

# ╔═╡ adb98511-bd5d-434a-b8a8-5fd31abf4bbe
begin
	n = 10
	🦈 = 0.3
	🐋 = 0.5
end

# ╔═╡ a546e01e-0df1-4eef-ae59-b076666d0e8d
println("After $(n) iterations, the populations of sharks and whales are respectively equal to 🦈=$🦈 et 🐋=$🐋")

# ╔═╡ 3d1b8158-89c2-4081-9f4e-6ed576eafce6
# Change the code above to use unicode symbols instead of alpha and beta

# ╔═╡ 3a19647e-beeb-457f-b0ef-bf57489dc21e
begin
	println("Baby 🦈")
	println("tdudtu")
end

# ╔═╡ 0036238a-bee3-4a03-8069-881e6f4b0d5c
md"""
### Logical Operations

Logical operators (==, <, <=, !=, >, >=) always return a boolean
"""

# ╔═╡ 6a65838a-9e04-4be9-b1b0-62bd87cceb36
b = 3

# ╔═╡ 44699ee4-e76a-40b8-a7ec-5df93382baec
a == b

# ╔═╡ 7dd94beb-8cfe-459a-a7bb-07751818822b
2 == 5.2

# ╔═╡ 215c56ca-3f9e-44c2-a042-50e80fe128af
nothing == Nothing

# ╔═╡ 1ce74c6e-c9c0-46bc-a581-ab0032bdb7d5
2 != 5.2

# ╔═╡ 5f3745bb-2434-4555-9620-81110d6f0014
2 < 5.2

# ╔═╡ 59a75dbd-de8b-4e64-8527-de846131a34b
md"""
They can be combined using logical operators '&' (and) and '|'
"""

# ╔═╡ 5d756046-e6bf-4907-ab2f-ade0089548ea
(2 < 3) & (1 < 2)

# ╔═╡ de2d6965-9a74-4ef6-baee-63d257eff77c
(2 < 3) |  (3 < 2)

# ╔═╡ 37fcff70-99ba-420b-bfb7-0dc027443851
md"""### More Julia
"""

# ╔═╡ b97a0549-8f42-42f7-a53f-ce11a930f160
# functions

# ╔═╡ 35fb094f-d8b0-4ab1-8055-31f668dd8561
# containers

# ╔═╡ 13a1773d-a5b5-4865-9c90-06a737c9a6de
# arrays

# ╔═╡ ac1c9204-ad29-4d20-8f5c-c94588e970f2
# control flow

# ╔═╡ bc806a5e-f029-40e2-a70a-d77e98d028f6
TableOfContents()   # from PlutoUI

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Bits = "1654ce90-6ed3-553a-957f-9452c3a40996"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Bits = "~0.2.0"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "0ebe67608050fc8f5fcb26233086d0ae1d16f134"

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

[[deps.Bits]]
deps = ["Test"]
git-tree-sha1 = "525d055f0c6b9476e6dcf032286383ea941a395c"
uuid = "1654ce90-6ed3-553a-957f-9452c3a40996"
version = "0.2.0"

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
# ╟─28618afa-99f6-11ee-102b-49f1a1b27f4a
# ╟─753379cc-d977-4ce9-9ded-b4699601046a
# ╟─550e6844-efaf-48a8-91f8-c27d40b7e3c3
# ╟─4a5d8ba0-dcc7-4ef3-9ebb-c8fad4a2b4eb
# ╟─ce753fef-a72a-4546-a8dd-1bcb490777df
# ╟─9ab5c25e-206c-4bdf-ad3f-6e237ab32814
# ╟─ae2bf128-f87e-4b59-a3b1-a71de9a72bbc
# ╠═7dffaab1-b630-43e3-b33a-e6fe83d3c6da
# ╟─605859a4-af1c-48dd-a174-14e77b56ff81
# ╟─0169f5f3-fe98-45c3-a945-026b24e31e26
# ╟─064ddccb-7679-4dc7-a443-d784e54947d0
# ╠═28df9d8a-eea7-4d43-8def-58ab0221a61e
# ╟─1750789d-d2f1-45d7-a3ff-554e061efade
# ╠═ad4ba04b-83b1-4394-a3d6-0429b4693129
# ╠═2b045036-f24c-4fc6-8e89-06c3d3ee0cca
# ╠═35cdd77b-66bc-49a7-89c0-acc7f4cb570c
# ╠═19f6a557-00fc-4a26-b828-aa843df67024
# ╟─c2320d66-897a-46d7-97f6-020f9271dd05
# ╟─7c24504b-040d-4a5b-acce-b972b8330e5f
# ╟─0014eaac-8106-4357-b27e-69ba81d10ae1
# ╟─49a15cab-0eda-4abb-9fe5-b166d070fe7b
# ╠═340c206c-edcc-4510-9828-ec7a69ba471e
# ╠═d25e5c35-b828-414f-a8a9-3b65de626464
# ╠═51887f62-310c-44d8-a2a2-57ad0072a56c
# ╠═decd77fe-d205-4f9b-8c96-35c865faf6b5
# ╠═43c15289-e95e-4d45-8416-44b0617297ca
# ╠═4dafa1c3-bca1-467a-9cba-ae9624d1b6d8
# ╟─71a3ac4a-7393-48dc-a174-6e256e1a06c1
# ╠═011f4cfc-8586-4737-ab4e-3a61c47dc39e
# ╠═53e05778-b13a-40b7-a2e0-f6a5bf0f26c3
# ╠═dd652d05-4837-4ca8-8109-bac0485d7fa6
# ╠═4d889960-c823-4be2-84da-07a7a517af44
# ╠═0b9a5da1-bfcc-4797-8372-ea859faabb61
# ╠═c6cd1035-acae-468c-8f37-0ec42cd1af8b
# ╟─2d5dcd90-6619-41d6-8900-50b1de500484
# ╟─dcedd483-eb89-4e43-8dd2-e7a2ba2bf354
# ╠═ab5e8fd2-87a4-4657-9ae5-1093639a514b
# ╠═4468a778-9b2a-468c-98ae-26a16916d12f
# ╠═6b600525-6ce4-40ce-ad26-6fecafa9bbac
# ╠═2451a56f-d9a0-4493-a2e1-fa4c9758215d
# ╟─b82920bc-4309-4c73-b348-589ae810af93
# ╟─40b2b811-de3d-4533-84d5-60297274f4ee
# ╠═adb98511-bd5d-434a-b8a8-5fd31abf4bbe
# ╠═a546e01e-0df1-4eef-ae59-b076666d0e8d
# ╠═3d1b8158-89c2-4081-9f4e-6ed576eafce6
# ╠═3a19647e-beeb-457f-b0ef-bf57489dc21e
# ╟─0036238a-bee3-4a03-8069-881e6f4b0d5c
# ╠═6a65838a-9e04-4be9-b1b0-62bd87cceb36
# ╠═44699ee4-e76a-40b8-a7ec-5df93382baec
# ╠═7dd94beb-8cfe-459a-a7bb-07751818822b
# ╠═215c56ca-3f9e-44c2-a042-50e80fe128af
# ╠═1ce74c6e-c9c0-46bc-a581-ab0032bdb7d5
# ╠═5f3745bb-2434-4555-9620-81110d6f0014
# ╟─59a75dbd-de8b-4e64-8527-de846131a34b
# ╠═5d756046-e6bf-4907-ab2f-ade0089548ea
# ╠═de2d6965-9a74-4ef6-baee-63d257eff77c
# ╟─37fcff70-99ba-420b-bfb7-0dc027443851
# ╠═b97a0549-8f42-42f7-a53f-ce11a930f160
# ╠═35fb094f-d8b0-4ab1-8055-31f668dd8561
# ╠═13a1773d-a5b5-4865-9c90-06a737c9a6de
# ╠═ac1c9204-ad29-4d20-8f5c-c94588e970f2
# ╟─a40c20dc-0473-4b14-b229-c2416f43422d
# ╟─bc806a5e-f029-40e2-a70a-d77e98d028f6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
