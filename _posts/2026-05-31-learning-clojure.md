---
layout: post
title: "How I learn Clojure"
date: 2026-05-31 09:48:53 +0100
location: London
categories: ['clojure', 'programming', 'process', 'learning']
summary: "Combining 4clojure, the clojure.core docs, and the Clojure source code"
---

I’ve been working with [Clojure](https://clojure.org) for a couple of years already. I’ve done Clojure work as a contractor, and [Parts](https://parts.ifs.tools), the project I spend most of my free time on, is written in it.

I learned Clojure the same way I learned most other programming-related things: by looking at examples and hacking stuff together, slowly building understanding along the way. However, last year, when I was trying to get my first Clojure job, I had a disastrous coding interview with [BG](https://beegee.xyz) (a kind of a legendary figure in the Clojure world), which made me realise that I didn’t actually _really_ know the language: without access to examples, I was useless.

In the debrief, BG shared some advice for actually getting good at Clojure: work through the problems on [4clojure](https://4clojure.oxal.org/) using only the [official documentation](https://clojure.github.io/clojure/clojure.core-api.html) (not [ClojureDocs](https://clojuredocs.org/clojure.core), which include examples!) and the Clojure [source code](https://github.com/clojure/clojure).

4Clojure is a collection of programming problems that teach you the standard library, each problem building on the one before it, kind of in the spirit of [The Little Schemer](https://vpb.smallyu.net/%5BType%5D%20books/The%20Little%20Schemer.pdf). The reason to go through it looking at source code rather than examples is to force you to reason from first principles (the implementation) rather than from someone’s ideas of how code is written.

So I’ve been working my way through 4clojure, until I came to Problem 53, “[Longest Increasing Subseq](https://4clojure.oxal.org/#/problem/53)”, which is the first “hard” problem I’ve encountered. I got stuck for a long while, but eventually managed to work my way through. Below, I’m documenting my thinking.

---

The problem:

> Given a vector of integers, find the longest consecutive sub-sequence of increasing numbers. If two sub-sequences have the same length, use the one that occurs first. An increasing sub-sequence must have a length of 2 or greater to qualify.

So, for an input of `[1 0 1 2 3 0 4 5]`, we should return `[0 1 2 3]`, which is the longest increasing sequence contained in the input sequence.

Ok, so thinking it through, to solve this we need three things:

1. A way to go through each sub-sequence in the input,
2. A way to check if a given sequence is an increasing sequence, and
3. A way to keep track of the longest such sub-sequence we’ve found so far.

### Going through each sub-sequence of the input

By the time I got back to this problem, I kind of forgot what the previous problems on 4clojure were about. I should have checked, because problems tend to build on knowledge learned in the previous ones, and thus I could have found a hint there.

Instead of checking, I got flashbacks of my misadventures trying to interview at big tech, and thought I remembered that the [two pointers approach](https://www.reddit.com/r/leetcode/comments/18g9383/twopointer_technique_an_indepth_guide_concepts/) could be useful here.

It went something like this:

```
p1 = 0
p2 = 0
increment p2 and check p1..p2 until p2 reaches the end of the input
then increment p1, p2 = p1 + 1, and repeat
```

Because I’m terrible at algorithms, what I ended up writing is not exactly the two-pointers approach, which is O(n), but rather an exhaustive O(n²) enumeration.

This function increments `p1` by using `rest`:

```clojure
(defn tail-subseqs [s]
  (take-while #(> (count %) 1) (iterate rest s)))
```

```
user> (tail-subseqs [1 0 1 2 3 0 4 5])
;; => ([1 0 1 2 3 0 4 5]
 (0 1 2 3 0 4 5)
 (1 2 3 0 4 5)
 (2 3 0 4 5)
 (3 0 4 5)
 (0 4 5)
;; =>  (4 5))
```

The `iterate` call returns an infinite sequence of `s`, `(rest s)`, `(rest (rest s))`, etc. Since we are only interested in sequences longer than 1, we `take` from it while the values `iterate` gives us are at least 2-long.

This function increments `p2` by using `take`:

```clojure
(defn head-subseqs [s]
  (map #(take % s) (range 2 (inc (count s)))))
```

```
user> (head-subseqs [1 0 1 2 3 0 4 5])
;; => ((1 0)
 (1 0 1)
 (1 0 1 2)
 (1 0 1 2 3)
 (1 0 1 2 3 0)
 (1 0 1 2 3 0 4)
;; =>  (1 0 1 2 3 0 4 5))
```

So now we have a way to move our two pointers.

### Check if a sequence is a sequence of increasing numbers

Naive approach: check if a sequence is the same as this sequence sorted.

```clojure
(defn inc-seq? [s] (= s (sort s)))
```

However, this actually only checked that the sequence is non-decreasing, not strictly increasing:

```
user> (inc-seq? [0 1 2 3 4])
;; => true
user> (inc-seq? [2 3 3 4 5]) ;; This seq is not strictly increasing
;; => true
```

So I thought I’d be clever and use a set:

```clojure
(defn inc-seq? [s] (= s (sort (set s))))
```

```
user> (inc-seq? [0 1 2 3 4])
;; => true
user> (inc-seq? [2 3 3 4 5])
;; => false ;; Nice!
```

This turned out to be problematic in its own way, as we will see later.

### A way to keep track of the longest increasing sequence we’ve found so far

I had a hunch that we could use `reduce` here, since we were basically trying to reduce a collection of subsequences into one subsequence (the longest incrementing one).

The reducing function passed to `reduce` takes two arguments: an accumulator, and an item from the collection we’re reducing.

- If the item is not an incrementing sequence, return the accumulator
- If the accumulator contains a longer (or equally long) incrementing sequence than the item we’re considering, return the accumulator. Otherwise, return the item.

The problem then becomes: how do we iterate through the sequences from `tail-subseqs` and `head-subseqs`?

We need to run `tail-subseqs` on each item returned from `rest-subseqs`, combine the output into a single sequence (we can use `mapcat`), and pass that to `reduce`:

```clojure
(defn longest-inc-subseq [s]
  (reduce
   (fn [acc item]
     (if (inc-seq? item)
       (if (> (count item) (count acc))
         item
         acc)
       acc))
   []
   (mapcat head-subseqs (tail-subseqs s))))
```

### Putting it all together

Now we can combine these pieces for a naive and rather verbose solution:

```clojure
(defn longest-inc-subseq [coll]
  (let [inc-seq?     (fn [s] (= s (sort (set s))))
        tail-subseqs (fn [s] (take-while #(> (count %) 1) (iterate rest s)))
        head-subseqs (fn [s] (map #(take % s) (range 2 (inc (count s)))))
        subseqs      (->> coll
                          tail-subseqs
                          (mapcat head-subseqs))
        reducer      (fn [acc item]
                       (if (inc-seq? item)
                         (if (> (count item) (count acc))
                           item
                           acc)
                         acc))]
    (reduce reducer [] subseqs)))
```

This passes the automated tests on 4clojure, and we can celebrate a little bit!

---

At this point, I will then look at the [community solutions](https://4clojure.oxal.org/#/problem/53/solutions) to see what others have come up with. This is usually where a lot of learning happens, because you can see how idiomatic Clojure is written, and how it’s often much more concise and elegant than whatever I’ve come up with.

Three things jumped at me immediately:

- `inc-seq?` can actually be rewritten as `(apply < s)`, which is much more elegant! `apply` takes two arguments: a function (in our case: `<`), and a sequence which will become the arguments vector in the function call. So if `s` is bound to `[1 2 3]`, `(apply < s)` is equivalent to `(< 1 2 3)`, which will return `true`.
- We can also use `partition`, which should’ve been obvious, because the previous few problems were focused on this particular function. As I mentioned above, I’ve missed this because I had been away from 4clojure for while.
- We can also turn this into a multi-step data processing pipeline thanks to threading.

So the final version of the function looks like this:

```clojure
(fn [xs]
  (->> (partition 2 1 xs)
       (partition-by (fn [[a b]] (< a b)))
       (filter #(apply < (first %)))
       (map (fn [g] (cons (ffirst g) (map second g))))
       (reduce (fn [best run]
                 (if (> (count run) (count best)) run best))
               [])))
```


Once I got here, I went through the solution expression by expression to make sure that I understand *why* exactly it’s working. I’d look up each function I’m not completely familiar with, reading the source of each, in addition to the docs. 

In this particular case, it was interesting to compare the source for `partition` ([GitHub](https://github.com/clojure/clojure/blob/8ae9e4f95e2fbbd4ee4ee3c627088c45ab44fa68/src/clj/clojure/core.clj#L3202)) and `partition-by` ([GitHub](https://github.com/clojure/clojure/blob/8ae9e4f95e2fbbd4ee4ee3c627088c45ab44fa68/src/clj/clojure/core.clj#L7308)). 

And that’s how we learn!
