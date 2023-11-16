#import "template.typ": *
#show: ams-article.with(
  title: "Pure Strategy Equilibria in Generalisations of the Election Game",
  authors: (
    (
      name: "Yi Chen Chong",
      department: [Department of Computing],
      organization: [Imperial College London],
      location: [London, SW7 2AZ],
      email: "ycc21@ic.ac.uk",
      cid: "02015150"
    ),
    (
      name: "Ranchen Li",
      department: [Department of Computing],
      organization: [Imperial College London],
      location: [London, SW7 2AZ],
      email: "rl3320@ic.ac.uk",
      cid: "01866869"
    ),
    (
      name: "Yichang Qin",
      department: [Department of Mathematics],
      organization: [Imperial College London],
      location: [London, SW7 2AZ],
      email: "yq621@ic.ac.uk",
      cid: "02017016"
    ),
  ),
  abstract: [
    The Election Game is a discrete variation on the classic Hotelling-Downs Model, in which $N$ politicians decide where along a (discrete) political spectrum (of $R$ positions) to position themselves to attract the most voters. Other than the trivial variants ($N = 0$ and $N = 1$), the $N = 2$ variant also is relatively simple, with politicians gravitating towards the one or two median positions, in line with the median voter theorem. However, more surprising behaviours arise for $N >= 3$. This paper describes an original method used to find all pure strategy equilibria for each $N > 0$ with the original posited $R = 10$ (which also carries over to any other value of $R$), and produces a brief analysis of some of the more surprising and exciting portions of the results (including some deviations from "median" behaviour).
  ],
  bibliography-file: "refs.bib",
)


In 1929, a brilliant mathematician and economic theorist by the name of Harold Hotelling at Stanford University proposed an economic model based on space. He imagined two sellers as points on a line, selling their goods, and that consumers preferred nearer sellers. While he was mainly talking about competitive pricing in the face of this spatial model, he also pointed out that it was strategically advantageous for the sellers to move towards each other @stabcomp. Variations on this have been applied to explain ideas ranging from logistics to politics.

In 2023, a different brilliant mathematics professor posed the following (paraphrased and slightly generalised) variation on the original Hotellings problem in a problem set. Consider the political spectrum modelled some number of discrete positions, numbered 1 through $R$ ($R$ in the original problem is given to be $10$). The players of the game are candidates seeking to achieve as much of the public vote as possible. A uniform proportion of voters ($frac(1, R)$ of all voters) is on each position, and voters will vote for whoever is closest to their position. In the event of a tie, the votes are split proportionally (e.g. if there is one candidate at pos. 1, and 3 candidates at pos. 3, with no candidates at pos. 2, half the voters at pos. 2 would vote for the candidate at pos. 1, and a sixth of them would vote for each candidate at pos. 3). @ps2

This paper attempts to address a generalisation of this problem, by finding and analysing the set of pure equilibria for $R = 10$, $forall N in NN$, and for some other values of $N$ and $R$. The original problem's solutions @ps2sol also contains a remark about how the equilibria of the $N = 2$ case has the candidates tending towards the centre, in an occurrence known as the "median voter theorem". We will explore how the generalised game deviates as it does not meet the conditions for the theorem.

To find the set of all equilibria for $R = 10$, we will start with the surprisingly easier case of $N > R$, which will help us find the set for $N = R$. We will then explore how the payouts work and are calculated, and gain the intuition for an efficient algorithm to compute whether or not a given portfolio of strategies constitutes a Nash equilibria, before computationally iterating through our solution set and find all possible equilibria for $3 <= N < R$ with $R = 10$ (and in fact, equilibria for all $R < 12$ are shown in our repository). Finally, this paper will present an analysis of some interesting findings. 


= Preliminaries
The most important preliminary concept to address is that the game is a symmetric game. The symmetry here is not spatial in nature (even though the game does have a sort of spatial symmetry to it). Rather, it means that the payoffs for playing any strategy depend only on the the strategies employed by other players @symgames. Intuitively, this must be true, as the problem did not define payouts for any specific player. Formally speaking, we define this as follows: for any permutation $pi$, $g_pi(i) (s_1, s_2, ..., s_i, ..., s_N) = g_i (s_pi(1), s_pi(2), ..., s_pi(i), ..., s_pi(N))$. In practice, this also means that whether a given portfolio of strategies is at equilibrium depends only on the number of candidates who choose each strategy @symgames. As such, for the purposes of this paper, we will be able to represent any portfolio of strategies with a vector of counts, where the value at position $i$ will represent the number of candidates who chose strategy $i$, which we will denote $sigma in RR^R$. This is a very useful feature of the game, as it drastically reduces our solution space, while allowing us to use some interesting features and variations of the representation to capture important information about the equilibria.

Another important note is that we are not dealing with the trivial cases where $N = 0$ or $N = 1$, or even the proven case $N = 2$. The paper will assume that $N, R > 2$, unless stated otherwise.

Finally, in terms of units, although the original problem uses payoff units to represent percentage points, this paper will use 1 unit of payoff to represent $1 / R$ of the votes. This is without loss of generality, and is just used to simplify the maths. The algorithm for verification actually uses units each representing $1 / (2R)$ of the vote to simplify the payoff equations, but the paper will use $1 / R$ as 1 unit unless otherwise stated.

#pagebreak()

= Pure Strategy Equilibria for $N >= R$

== Pure Strategy Equilibria for $N > R$
When looking at cases for $N > R$, a relatively intuitive conjecture, later proven, came to mind:

#proposition[
  A pure strategy portfolio $sigma$ for $N > R$ represents an equilibrium if and only if $sigma$ is "_almost flat_", where almost flat is defined as having the property that all values of $sigma$ are either $floor(N / R)$ or $floor(N / R) + 1$, and $floor(dot)$ represents the floor (round down) function.
]
#proof[
  We prove this is the case with a separate proof in each direction.
  #v(0.4em)
  
_Proof that $sigma$ represents a pure strategy equilibrium if it is "almost flat":_
#set par(first-line-indent: 2em)
#set par(hanging-indent: 2em)
#v(0.25em)
Assume $sigma$ almost flat and let $eta = floor(N / R)$. For $N >= R$, $N / R >= 1$, so $eta >= 1$, and therefore we have that there must be at least one candidate at every position. Therefore, for any position $i$, the payoff of a candidate at position $i$ is $1 / sigma_i$, which is either $1 / eta$ or $1 / (eta + 1)$. If a candidate were to move to a different position $j$, his new payoff would be $1 / (sigma_j + 1)$, which is either $1 / (eta + 1)$ or $1 / (eta + 2)$. Since $eta >= 1$, we have that $1 / eta > 1/ (eta + 1) > 1 / (eta + 2)$, and therefore, $forall i, j, 1 / (sigma_j + 1) < 1 / (sigma_i)$. Therefore, with an almost flat $sigma$, there is no incentive for any candidate to change positions, 
#v(0.7em)
#set par(first-line-indent: large-size)
#set par(hanging-indent: large-size)

_Proof that if $sigma$ represents a pure strategy equilibrium, it must be "almost flat":_
#set par(first-line-indent: 3em)
#set par(hanging-indent: 2em)
#v(0.25em)
Assuming that $sigma$ is not almost flat, we will prove that it is not a pure strategy equilibrium.

First, consider the case where $forall i, sigma_i > 0$, i.e. every position has at least one candidate. We will take $i : sigma_i = min_n {sigma_n}$ and $j : sigma_j = max_n {sigma_n}$. Since we know that the mean value must be between the minimum and maximum values, we have that $sigma_i <= N / R <= sigma_j$. Since there exists values $sigma_n : sigma_n != floor(N / R) and sigma_n != floor(N / R) + 1$, we know that either $sigma_i < floor(N / R)$ or $sigma_j > floor(N / R) + 1$. Therefore, $sigma_j > sigma_i + 1$. The current payoff at $j$ is $1 / sigma_j$, and the payoff if a candidate from $j$ decides to switch positions to $i$ is $1 / (sigma_i + 1) > 1 / sigma_j$. Therefore, a candidate at $j$ would benefit from switching over to the candidate, meaning this is not a pure strategy equilibrium.

Next, considering the case where $exists i: sigma_i = 0$. We call $i$ a "_gap_" in the positions. The payout for switching to a gap is always at least $1$, as the voters on position $i$ would all vote for the only candidate that is on the position. We employ a probabilistic argument. On average, each candidate currently receives $R / N$ votes, which means that some candidates receive payouts $<= floor(R / N)$. Since $N > R$, these candidates receive $< 1$ votes, and would benefit from switching over to position $i$, where they would gain at least one vote. Therefore, $sigma$ also would not represent a pure strategy equilibrium.
]
#v(-2em)
#linebreak()
=== Set of Pure Strategy Equilbria $forall N > R$
With this proposition, we can now construct the set of pure strategy equilibria $forall N > R$. We know that there must be $N mod R$ positions with $floor(N / R) + 1$ candidates (necessary for there to be $N$ total candidates). Therefore, we have $vec(R, N mod R)$, as in $R$ choose $N mod R$, combinations of candidates fulfilling this. An interesting consequence is that for $N > 2R$, we can just find the solutions for $N - 10$, and add a candidate to each position in each soluion. The set of pure strategy equilibria for $R = 10, 11 <= N <= 20$ has been included.

\

== Set of Pure Strategy Equilibria for $N = R$

Note that the only part of the proof for $N > R$ that does not apply to $N = R$ is the case where $exists i : sigma_i = 0$. For $N = R$, the average payout is exactly $1$, and therefore, we have to address cases where (1) the minimum payout is also $1$ (i.e. every candidate has a payout of $1$), and (2) that the payout of moving into a gap are also 1.

Any gaps that are of size $>= 2$ would mean that the payoff of moving into one would be at least $1.5$, violating (2). We can therefore assume all gaps are of size 1. For a gap to exist when $N = R$, there must be a position with at least 2 candidates by the pigeon-hole principle _(p.h.)_. $n$ candidates at a position not next to any gaps each get $1 / n$ votes; candidates at a position next to a gap that is not at an extreme end of the spectrum each get $1.5 / n$ votes; candidates surrounded by gaps, each get $2 / n$. Obviously, the first two cases would violate (1); the third is only possible if each position has at most 2 candidates, and, letting $x$ be the number of positions with 2 candidates, there must be $x + 1$ gaps to surround each, contradicting _p.h._

Therefore, the only alternatives to the "almost flat" equilibrium are if the extreme position is a gap, followed by 2 players (i.e. the first position is a gap and the second position has 2 candidates, and/or if the second position has 2 candidates, and the third position has a gap), meaning there are four equilibria for $N = R$ : $sigma in {(0, 2, 1, ..., 1), (1,  1, ..., 1, 2, 0), (0, 2, 1, 1, ..., 1, 2, 0), (1, 1, ..., 1)}$.

#v(1em)
#pagebreak()
= Payouts and a Novel Efficient Algorithm for the Verification of Pure Strategy Equilibria

The payouts for the game are quite complicated, as the payout functions for a candidate given the strategies for all other candidates is not smooth or continuous. As such, we could not find a method to formulate the set of equilibria in the generalised case. However, we can build up to an algorithmic approach to determine whether a portfolio is at equilibrium and generate all such portfolios. Let us start by computing the payouts for some number $I$ of candidates, given a portfolio of other candidates' positions $sigma = [0, 0, ..., A, 0, ..., 0, B, 0, 0, ...]$, i.e. $sigma$ is zero, apart from arbitrary positions $a, b$, where there are already $A$ and $B$ (quantity of) candidates respectively. We break down the payouts if the candidates position themselves at different locations along the spectrum (let us call the new candidates' position $i$):

#table(
  columns: (0.2fr, 1fr),
  inset: 5pt,
  [*Positioning*], [*Payout*],
  [$i < a$], [Each new candidate's payout would be the number of votes on and to the left of $i$ per candidate ($i / I$) plus half the votes between $i$ and $a$ per candidate ($(a - i - 1) / (2I)$). Summing the two, you get $(a + i - 1) / (2I)$. Interestingly, as this is linear with respect to $i$, the strategy of positioning $i = a - 1$ strictly dominates all other strategies $i < a$. Therefore, the optimal payoff for $i : i < a$ is $(a + (a - 1) - 1) / (2I) = (2a-2) / (2I)$.],
  $i = a$, [This is equivalent to placing $A + I$ candidates at positon $a$ in a previous portfolio with only $B$ at position $b$, giving us a payoff per candidate of $(a + b + 1) / (2(I+A))$.],
  [$a < i < b$\
  (Assuming $a > b + 1$)], [The total payout is equal to the vote at $i$ ($1$), plus half the candidates between $a$ and $i$ ($(i - a - 1) / 2$), and half the candidates between $b$ and $i$ ($(b - i - 1) / 2$). Summing together and dividing by $I$, we get $(b - a) / (2I)$ votes per candidate.],
  [$i = b$], [The spatial symmetry of the situation means we can use the same computations as when $i <= a$, giving us $(2R + 1 - a - b) / (2(I+B))$.],
  [$i > b$], [As before, the payoff is $(2R+1 - i - b) / (2I)$, but the optimal payout is $(2R - 2b) / (2I)$.]
  
)

Given this, our calculations show us that the payouts for any individual candidate at position $i$ are:

$ cases(
  (2a - 2) / (2I) "if" exists.not j : sigma_j > 0 and j<i "and" a "is the candidate at the next position" ,
  (b - a) / (2I) "if " a < i < b and exists.not j:sigma_j != 0 and (a<j<i or i<j<b),
  (2R - 2b) / (2I) "if" exists.not j : sigma_j > 0 and j>i "and" b "is the candidate at the next position".
) $

To compute the payouts given any portfolio, we create a list $chi$ of non-empty positions (not a vector, as it has arbitrary length, but we will still denote the value at the $i^(t h)$ position as $chi_i)$, and another list $upsilon$ of the number of candidates at position  $chi_i$. Note that $(chi, upsilon)$ fully describes all the information in $sigma$ and vice versa -- they are equivalent representations. Their length (which is equal) will be denoted by $l < min(N, R)$. This allows us to ignore all positions with no candidates, as they do not affect the payoffs. We then create a new list using $chi$ as follows:
$ [-1, 2chi_1-1,0,chi_2-chi_1,0,chi_3-chi_2,0,...,chi_l-chi_(l-1), 0,2R+1-2chi_(l), -1] $ and take a moving sum (with window size 3) $delta$ of that new list, so we get:
$ delta = [2chi_1-2, chi_1+chi_2-1,chi_2-chi_1,chi_3-chi_1,chi_3-chi_2,...] $
You will notice that this list represents twice the total payoffs for candidates (the numerators of the piecewise function) if they position before $chi_1$ (optimally), at $chi_1$, between $chi_1$ and $chi_2$, at $chi_2$, and so on. Therefore, if we take $delta'=[delta_2, delta_4,delta_6,...]$, and divide $delta' / (2upsilon)$ element-wise (all division between lists will be assumed to be element-wise), we get a list of payoffs for candidates at position $chi_i$.

If we take $upsilon' = [1, upsilon_1+1, 1, upsilon_2+1, 1, upsilon_3+1,...]$, then $delta / (2upsilon')$ represents the payoffs for a new candidate if they position before $chi_1$, at $chi_1$, between $chi_1$ and $chi_2$, at $chi_2$, and so on.

== Naive algorithm

We can use these results to develop a naive algorithm to verify whether or not a given portfolio of strategies is a Nash equilibrium. We first convert $sigma$ into $(chi, upsilon)$, and compute $delta' / (2upsilon)$. For every $chi_i$, we compute $sigma^((i)) = (sigma_1,sigma_2,...,sigma_(chi_i) - 1, sigma_(chi_i + 1), ..., sigma_N)$ (i.e. the modified portfolio where a candidate at $chi_i$ has recanted his decision, and can redecide his position). For every $sigma^((i))$, we can calculate their equivalent ($chi^((i))$, $upsilon^((i))$) representation, and use that to calculate $delta^((i)) / (2 upsilon^(i)')$, which are the payoffs if $chi_i$ repositions. Therefore, $exists i : (delta' / (2upsilon))_i <max{delta^((i)) / (2 upsilon^(i)')}$ means that a candidate at $chi_i$ could reposition to achieve a higher payoff than his current payoff, and therefore we have that $sigma$ represents equilibrium if and only if $forall i, (delta' / (2upsilon))_i >= max{delta^((i)) / (2 upsilon^(i)')}$.

This algorithm is functionally correct, and can be used to quickly determine whether a given portfolio of strategies is a Nash equilibrium. However, it is far from ideal. The goal of this verification function is to search through an entire solution space, and determine which solutions are equilibria. We will see that the solution space we are searching through has size on the order of $vec(R + N - 1, N)$, and so this verification algorithm needs to be extremely efficent to be used on the entirety of a factorial-time search space. The algorithm in its current form has an asymptotic complexity of $O(l^2)$. Obviously, the algorithm could not do any better than $O(l)$, as it needs to, at least, iterate through and read all non-zero values of $sigma$, of which there are $l$, and we will show that it is possible to achieve that lower bound.

== A more efficient implementation

The key mathematical observation that leads to the major reduction in runtime is that many of the lists of mutated payoffs $delta^((i)) / (2 upsilon^(i)')$ are extremely similar. In fact, if you take the original $delta / (2upsilon)'$, the only difference that it has with any $delta^((i)) / (2 upsilon^(i)')$ are in the positions near $chi_i$, more specifically between $chi_(i - 1)$ (or 1, if $i = 1$) and $chi_(i + 1)$ (or R, if $i = l$), inclusive. This makes sense -- the payoff at any position is only affected by the number of candidates at that position and the distance to the nearest non-zero positions. We will call $delta^((i)) / (2 upsilon^(i)')$ the "_general mutated payout list (GMPL)_", denoted $g'$, and $delta^((i)) / (2 upsilon^(i)')$ the "_specific mutated payout list (SMPL)_" for position $chi_i$, denoted $g^((i))$. Let us also denote the general mutated payoff describing position $i$ as $g'(i)$. Let us compare the payoffs.

First, let us address the case where $upsilon_i > 1$. As the position would still have $sigma_i^((i)) > 0$, it would still be $chi_i^((i))$, albeit with $upsilon_i^((i)) = upsilon_i - 1$. Since the only change is in $upsilon_i^((i))$, and $upsilon_i$ only affects the payout at point $i$, the SMPL only differs from the GMPL where it describes point $i$, where the SMPL's payout is equal to the current payout (if the candidate reconsiders his position but doesn't move, he'll have his current payout). Since the payout at point $i$ has a smaller denominator in the SMPL for the same numerator, the general mutated payout must be smaller than the current payout. That means that the maximum of the SMPL is greater than the current payout if and only if the maximum of the GMPL is greater than the current payout.

Next, supposing that $upsilon_i = 1$ suppose we will take the case where the $chi_i$ in question is not first or last (i.e. $i != 1 and i != l$). There are five payoffs described in the GMPL pertaining to the region $[chi_(i-1), chi_(i + 1)]$, at point $chi_(i-1)$, between points $chi_(i-1)$ and $chi_i$, at point $chi_i$, between points $chi_i$ and $chi_(i+1)$, and at point $chi_(i+1)$. For the region $(chi_(i-1), chi_(i+1))$, these payouts are $(chi_(i) - chi_(i-1))/(2), (chi_(i+1)-chi_(i-1))/(4),$ and $(chi_(i+1)-chi_(i))/2$ respectively. In the SMPL, any point in the region $(chi_(i-1), chi_(i+1))$ has the payoff $(chi_(i+1)-chi_(i-1))/2$, which, again, is equal to the current payout and greater than those particular mutated payouts. At the boundary of the region, points $chi_(i-1)$ and $chi_(i+1)$, the payout also is higher in the SMPL than in the general list (intuitively, they gain some of the votes that went to $chi_(i)$, but the proof requires breaking down each case of what lies beyond the boundary), but their specific payouts may be higher than the current payout. The same is true about the first and last points, where the only positions where the specific mutated payout may be higher than the current payout are at $chi_2 - 1$ or $chi_(l-1)+1$, and $chi_2$ or $chi_(l-1)$.

In summary, this means that the maximum of the SMPL for position $chi_i$ is:
$ max_(n in [1, R]) {g^((i))(n)} =cases(
  gamma ", if" upsilon_i = 1,
  max{gamma, g^((i))(chi_2 - 1), g^((i))(chi_2)} ", if " upsilon_i 
 > 1 and i=1,
  max{gamma, g^((i))(chi_(l-1)+1), g^((i))(chi_(l-1))} ", if " upsilon_i > 1 and i=l,
  max{gamma, g^((i))(chi_(i-1)), g^((i))(chi_(i+1))} ", otherwise"
) \
"where" gamma = max_(n in [1, R]) {g'(n)} $

When computed, the specific mutated payouts that still need to be calculated actually turn out to be neat combinations of general mutated and current payouts that don't require much recomputation (e.g. in the final case of the above equation, $g^((i))(chi_(i-1)) = g'(chi_(i-1)) + (chi_(i+1) - chi_i) / (upsilon'_i)$). This means that the Nash equilibrium can mostly be verified by calculating the maximum of the GMPL, along with up to two exceptions per $chi_i$. The new algorithm runs in $O(l)$ time.

Several other computational optimisations helped to reduce the runtime of this algorithm. These include writing the algorithm itself as a binding in C, and using sliding window techniques to compute the moving sums and payouts in only one iteration of $chi$ and $upsilon$. However, the computational techniques used are not the focus of this paper, and will not be discussed in too much detail here. The final implementation of my search and validation algorithms is on the GitHub repository @github.

== Searching the Solution Set

We find all equilibria for a given $N, R$, by taking a set containing potential portfolios of strategies, and filtering it through the validation algorithm. We use Satisfiability Modulo Theorem (SMT) libraries, specifically _Z3_, a program developed by Microsoft Research to efficiently iterate through a solution space defined by several crude constraints. However, the validation algorithm itself proved too unwieldy to write in the constraint format, and that was therefore applied to the output of the SMT solver. Maintaining a small enough search space was a crucial problem. The size of the set of all $sigma$ representing portfolios of $N, R$ is effectively the number of ways to sort $N$ indistinct items into $R$ distinct baskets, which is $vec(R + N - 1, N)$. This is quite a large set to search through, so we actually generate the portfolios using an analogous representation that is easier to apply some more constraints to.

We consider $L in NN_+^N$ as a representation of $sigma$, where each $L_i$ represents a candidate's position. If you do away with permutations by only considering $L : forall i < N - 1, L_(i) <= L_(i + 1)$, it is apparent that there is a bijection between the set of $L$ and the set of $sigma$, and therefore they have the same cardinality. However, it is now easier to preemptively enforce some constraints on the set. For example, the previously-mentioned constraint that the most extreme candidate in a certain direction can not be two or more positions away from the second most extreme candidate in that direction (as it is advantageous for him to move medially), can be applied by enforcing that $L_2 - L_1 < 2$ and $L_N-L_(N-1)<2$.

Another constraint applied is related to the probabilistic method used in the $N > R$ proofs earlier. If the average payout of each player is $R / N$, then any gaps in $L$ big enough such that the payout of moving into them is greater than $R / N$, and $L$ could not represent an equilibrium, as there are players who would benefit from moving into the gap. A gap of size $floor(R / N) + 1$ at the extremal values and $2floor(R / N) + 1$ otherwise is large enough for this to happen, so we also enforce the following constraints: $L_1 <= floor(R / N) + 1, L_N>=R-floor(R/N), forall i in [2, N], L_i-L_(i-1) <2floor(R/N)$.


= Results and Analysis

We first ran our completed program over $3 <= R <= 12$ and $2 <= N < R$. The full results, in their $L$ representations, are in the GitHub repository @github in CSV format. The $R = 10$ are also included in the table below.

#figure(caption: [Equilibria for $R = 10$, $3 <= N <= 9$], placement: bottom)[
  #box(height: 22em)[
    #columns(4, gutter: 0.1em)[
      #set text(size: 8pt)
      #let data() = {
        let output = ()
        for i in range(4, 10) {
          output.push([#i])
          let csv_name = "data/" + str(i) + ".csv"
          let rows = csv(csv_name).map(it=>"(" + it.join(", ") + ")")
          let content = rows.map(it=>{[#it]}).join("\n")
          output.push(content)
        }
        return output
      }
      // #data()
      #table(
        columns: (auto, auto),
        inset: 3pt,
        align: center,
        [*$N$*], [*$L$ in Equilibrium*],
        [3], [None],
        ..data()
        
        
      )
    ]
  ]
]

It is interesting to note that there is no equilibrium for $R = 10$, $N = 3$, but this fact could actually be computed from some of the constraints we had earlier. $floor(10 / 3) = 3$, so we have $L_1 <= 4$, $L_3 >= 7$. We also know that $L_2 - L_1 < 2$ and $L_3 - L_2 < 2$. These four constraints are clearly contradictory, and so there can not be equilibrium for $N = 3$. In fact, there are no equilibria for $N=3$, $forall R>4$. The constraints imply that $(R - floor(R/3)) - (floor(R/3)+1) <= 2$, which gives us that $floor(R/3) >= (R-3)/2$. As the $(R-3)/2$ part of the equation clearly outpaces the $floor(R/3)$ component, so there is a finite set of $R$ where this equation is true. The only $R$ where this is true are $1, 2, 3, 4, 5, 7, 9$, of which the cases where $R <= N$ obviously have their almost $N$ solutions. Testing $R$ at the remaining positions shows that only $R=4$ yields any equilibria. This value of $N$ is extremely unique, as the difference $< 1$ constraints proves to be incredibly restrictive, rendering an equilibria with $N = 3$ impossible to achieve for large enough $R$. For $N = 4$, for example, these few constraints, even with the addition that gaps can not be larger than $2floor(R/4)+1$, still have solutions for all $R$.

Another interesting point is that, qualitatively, the "shape" of the equilibria appears to remain relatively constant for any given $N$, $R$, s.t. $N < R$. We can quantify how "constant" this shape is by constructing a metric space for the equilibria and measuring the average distance between any two different points in the set.

To do this, we use the earth-movers distance (EMD) metric to quantify this. Informally, the Earth Mover's Distance is defined as follows: Imagine two  distributions as two ways of piling up dirt over their domain $D$; the EMD is defined as the minimum cost of transforming one distribution into the other if moving one unit of weight (in dirt) one unit of distance along $D$ is one unit of cost. @emd For our particular distribution, we normalise it so that we define 1 unit of weight as $N$ candidates, and 1 unit of distance as $R$ (i.e. the cost of moving a single candidate $x$ positions is $x / (N R)$). For example, let us compute the average distance of the set of equilibria for $N=4, R=10$ by hand. You can get from the first distribution in the table to the second by moving a candidate from position 4 to position 3, which has a cost of $1 / 40$. The cost of moving from the second to third positions is also $1 / 40$ likewise, and the cost of moving from the first to the third positions is $1 / 20$ (as two candidates need to be moved). Therefore, the average distance of the set is $1 / 30$ (let us denote this as $E_(4, 10) = 1 / 30$). This computation is much more tedious for larger sets, as the sets must be compared pairwise; we wrote code to find the average distance of the sets, and it is also included in the GitHub repository @github.

For a control benchmark, we use the expected EMD between distributions generated where each candidate chooses a position randomly. While the expected EMD is very difficult to mathematically compute, we can estimate it by taking a sample of possible distributions of $N$ candidates over $R$ positions (we took 100,000 samples) and taking their average. We denote these estimated values as $macron(d)_(N, R)$. Comparing these to the average distance within the set of equilibria for any given $N, R$, the data shows that the average distance is, in our experimental cases, significantly smaller than the expected EMD between random distributions, showing that a given $N, R$ equilibria has a distinct "shape". For example, we computed that $macron(d)_(4, 10) = 0.199965$, which is significantly larger than our average distance of $0.03333$. We have tabulated some other results from $R = 10$ below, but the pattern appears to continue for different $R$. The data for $R <= 12$ has been computed and is in the GtHub repository.

#figure(caption: [Equilibrium Average Earth Mover Distances and Expected Earth Mover Distances for a given $N$, where $R=10$])[
  #table(columns: 7,
    [*$N$*],[*4*],[*5*],[*6*],[*7*],[*8*],[*9*],
    [*$E_(N,10)$*], [$0.033$], [$0.033$], [$0.033$], [0.0641], [0.047], [0.031], 
    [*$macron(d)_(N,10)$*], [0.200], [0.182], [0.167], [0.156], [0.146], [0.139],
  )
]

A final relatively surprising finding is that the model does not appear to exhibit "middling" behaviour - at equilibria, the candidates are not all positioned near the median. A finding called the "median voter theorem" predicted that many election models should be won by the candidate occupying the position nearest to the "median" voter @black @bc2014. That usually means that the distribution should be closer to the median position at equilibria (as observed by Hotelling) @stabcomp, or at least have a candidate as close as possible to the median position, as getting closer to the median position would be beneficial. However, this is not the case.

The issue is that our model does not fulfill the criterion for the theorem - the "Condorcet winner criterion". An election model satisfies the Condorcet winner criterion when, if a "Condorcet winner" exists, the Condorcet winner is also the overall winner. A "Condorcet winner" is defined as a candidate who would win against each other candidate in a two-candidate election. @bc2014 In some senses, you can think of a Condorcet winner as the most popular candidate pairwise. A simple counterexample shows that our model does not fulfill the "Condorcet Winner Criterion". Let $L = (3,5,7)$. Obviously, the candidate at position 5 would win in elections defined by $(3, 5)$ and $(5, 7)$. However, in this election, the candidate actually gets the least votes (only $2$ votes), compared to $4.5$ votes for the candidate at $7$ and $3.5$ votes for the candidate at $3$. Intuitively, it makes sense why this means the median voter will not win. A candidate at the median position may get "choked out" by candidates on either side, even though the median candidate may be more popular pairwise than every other candidate.

= Areas for further research
Mathematically, there are several possible areas of further research. The "distinct shape" of equilibria given $N, R$ could be compared with the shapes of other equilibria. We conjectured that this shape may be related to either the mixed strategy equilibria, or the equilibria if the positions were contnuous rather than distinct, but were only able to compute those equilibria for a few cases, and so did not find a way to experimentally or mathematically verify this. There are also probably other patterns between the set of equilibria of different $N, R$ that may imply useful properties for computation. For example, the size of the set of equilibria for $N = R - 1$ appears to be $4R-20$, which may suggest some sort of patterns in the cases where $N = R - 1$. Finding these patterns may be extremely useful, as cases like $N = 11, R = 12$ have proven extremely time intensive.

Computationally, the next step would be to try to transfer the validation formula into SMT-compatible constraints to try to take advantage of potential optimisations from Z3's symbolic reasoning engine.
#pagebreak()
