<h1>Pure vs Impure Function</h1>

<h2>Impure Function</h2>
A function becomes impure when it:
<ul>
  <li>Mutates a global value</li>
  <li>Mutates a passed parameter</li>
  <li>Interacts with a global class</li>
</ul>

<h2>Pure Function</h2>
A function that does not have any side effects  
and does not mutate any global value.


<h1>Immediate vs Lazy Execution</h1>

<h2>Immediate Execution</h2>
An operation that executes **immediately** and returns results right away:
<ul>
  <li>Example: calling <code>ToList()</code>, <code>Count()</code>, or <code>Sum()</code> on a LINQ query</li>
  <li>Results are computed at the point of the call</li>
  <li>Subsequent changes to the source collection do NOT affect the result</li>
</ul>

<h2>Lazy (Deferred) Execution</h2>
An operation that is **deferred** until the results are actually needed:
<ul>
  <li>Example: defining a LINQ query without calling <code>ToList()</code> or <code>Count()</code></li>
  <li>The query is only executed when you iterate over it (e.g., with <code>foreach</code>)</li>
  <li>Subsequent changes to the source collection **will affect the results** when executed</li>
</ul>
