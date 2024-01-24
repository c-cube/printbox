


|             |       |          |
|-------------|-------|----------|
|             | min   | -89.2 °C |
| Temperature |       |          |
| 1961-1990   | mean  | 14 °C    |
|             | min   | 56.7 °C  |


> trying
> > nested
> > > quoatation

**`bold code`**<br>
`code`

> List 1:
> - Element 1
>   second line of element 1
> - Element 2
>   - Subelement 3
>   - Subelement 4
>     > Some<br>
>     > more
>     > <details><summary>Header 5</summary>
>     >
>     > - Subelem 6
>     > - Subelem 7
>     > </details>

Framed fold:

> <details><summary> List 2: </summary>
>
> - Element 1<br>
>   second line of element 1
> - Element 2
>   - Subelement 3
>   - Subelement 4
>     > Some<br>
>     > more
>     > <details><summary>Header 5</summary>
>     > 
>     > - Subelem 6
>     > - Subelem 7
>     > </details>
> </details>


> <details><summary> `List 3:` </summary>
>
> - Element 1
>   second line of element 1
> - Element 2<ul>
>   <li>Subelement 3</li>
>   <li>Subelement 4
>     >
>     > Some<br>
>     > more
>     > <details><summary>Header 5</summary>
>     >
>     > - Subelem 6
>     > - Subelem 7
>     > </details></li>
>   </ul>
> </details>


<details>
<summary> [Hyperlink header](./playground.md) </summary>

- [Hyperlink 1](../../test/test_md.ml#L19)
- [Hyperlink 2](../../test/test_md.ml#L23)
- [Hyperlink 3](../../test/test_md.ml#L8)
- [Hyperlink 4](../../test/test_md.expected#L23)
</details>

[This is
**multiline**<br>
hyperlink](../../test/test_md.expected#L23)

**This is
multiline<br>
bold text**

`this is
multiline<br>
  code`

```
this is
multiline<br>
  code
```

<span style="font-family: monospace">this is
multiline<br>
  broken code</span>

> `this is
> multiline<br>
>   code`

> ```
> this is
> multiline
>   code
> ```

> <span style="font-family: monospace">this is
> multiline<br>
>   code</span>



<span style="color: red">
```
this is
multiline<br>
  colored code
```
</span>


<span style="color: red">

```
this is
multiline
  colored code
```

</span>

<span style="color: red">`one line red? code`</span>
**`bold code`**

> <pre>
> this is
> multiline
>   code
> </pre>

<pre><span style="color: red">this is
multiline
  colored code
</span></pre>

> <code>
> this is<br>
> multiline<br>
>   broken code
> </code>

<code><pre>
this is
multiline
  broken code
</pre></code>

<pre><code>
this is too much space
multiline
  code
</code></pre>

<pre><code>this is
multiline
  code
</code></pre>

Trying this <pre>one-line code</pre> is not inline.

VS Code Markdown previewer does not respect the semantics of `white-space: pre` -- unfortunately we still need to use `nbsp` to prevent collapsing white spaces.

<dev style="font-family: monospace; white-space: pre">this is
multiline
&nbsp; code line 1
&nbsp;&nbsp;code line 2
    code line 3
     code line 3
 &nbsp; code line 4
&nbsp;code line 4
 &nbsp;code line 5
</dev>

Using `white-space: pre` to prevent line breaks:

<dev style="white-space: pre">This is a very long line, let's check if it will break, or if a horizontal ruler will appear. | This is a very long line, let's check if it will break -- oh nice, a horizontal ruler has indeed appeared. | That's definitely nice and more readable.</dev>

Using `<pre>`:


What happens with <returns> say & also `<returns>` html-ish syntax? &lt; and &gt; -- hmm &amp; only if it's &something; recognized?

row 1<br>row 2<br>row 3

row 1<hr>row 2<hr>row 3

<span style="border-bottom:thin solid">row 1</span><br><span style="border-bottom:thin solid">row 2</span><br>row 3

- row 1
- row 2
- row 3

---

- Line 1
  > ---
- Line 2.1<br>
  Line 2.2
  > ---
- Line 3

Header 1 | Header 2
---------|---------
  Row 1  | Row 1
Row 2    | <span style="border:thin solid">Row 2</span>
Row 3    | Row 3
<dev style="white-space: pre">some long text possibly long long text</dev> | <span style="white-space: pre">some long text possibly long long text</span>

Text formatting:

*emphasis?*even*!?*more*Is it always emphasis?* Just one star: * is always * a star.

_ is _ and _not is_ not. But _is_not is_. is _._ a _?


` <this works > as fuck&nbsp;\t   not`