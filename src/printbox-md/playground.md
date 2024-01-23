


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

<span style="font-family: monospace">this is
multiline<br>
&nbsp;&nbsp;code line 1<br>
&nbsp; code line 2</span>

What happens with <returns> say & also `<returns>` html-ish syntax? &lt; and &gt; -- hmm &amp; only if it's &something; recognized?