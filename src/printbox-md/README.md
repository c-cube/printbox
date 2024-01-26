# PrintBox-md: a Markdown backend for PrintBox

## Coverage of Markdown and `PrintBox` constructions

### Single-line and multiline text

Multiline text is printed using Markdown's syntax for forced line breaks:  
· a pair of trailing whitespace.  
· · Line wrapping is not prevented unless the text is styled as preformatted.  
· However, we pay attention to whitespace in the text · · -- ··   
we don't allow HTML to ignore the spaces.


```
Preformatted text like this one can be output in two different styles:
  Code_block and Code_quote.
    The style can be changed for both multiline and single-line text.
```


`So it is possible to use [Code_quote] even with multiline text,`  
`· which leads to a contrasting visual effect.`  
`· · Since Markdown's code quotes would otherwise · · ignore whitespace,`  
`· we use our trick to preserve --> · · · · · · · · · these spaces.`

### Horizontal boxes i.e. `PrintBox.hlist`

The &nbsp; `` `Minimal `` &nbsp; style for horizontal boxes simply puts all entries on a line,  &nbsp; separated by extra spaces,

or if \`Bars are set, |  by the | vertical dash.

<div>
 <table class="framed">
  <tr class="">
   <td class="">
    <div class="">It only works when<br/>all the elements fit</div>
   </td><td class=""><div class="">logically speaking,</div></td>
   <td class=""><div class=""><b>on a single line.</b></div></td>
  </tr>
 </table>
</div>



<div>
 <table class="non-framed">
  <tr class="">
   <td class=""><div class="">Otherwise, the fallback behavior is as if</div>
   </td>
   <td class=""><pre class="" style="font-family: monospace">`As_table</pre>
   </td>
   <td class=""><div class="">was used to configure horizontal boxes.</div>
   </td>
  </tr>
 </table>
</div>



### Vertical boxes i.e. `PrintBox.vlist`

- Vertical boxes can be configured in three ways:
- `` `Line_break `` &nbsp; which simply adds an empty line after each entry
- `` `List `` &nbsp; which lists the entries
- and the fallback we saw already, &nbsp; `` `As_table ``

Vertical boxes with bars  
> ---
`(vlist ~bars:true)` &nbsp; use a quoted horizontal ruler  
> ---
to separate the entries (here with style \`Line_break).

### Frames

> Frames use quotation to make their content prominent  
> > ---
> except when in a non-block position &nbsp; [then they use] &nbsp; square brackets  
> > ---
> (which also helps with conciseness).


```
┌─────────────────────────────────────────────────────────────────┐
│There is also a fallback                                         │
├─────────────────────────────────────────────────────────────────┤
│which generates all┌─────────────┐the same approach as for tables│
│                   │frames, using│                               │
│                   └─────────────┘                               │
└─────────────────────────────────────────────────────────────────┘
```


- This even works OK-ish
- when the frame
- 
  ```
  ┌─────────┐
  │is nested│
  └─────────┘
  ```
  
- inside Markdown.

- And suprisingly it works even better
- - when tables are configured
  - <div><div style="border:thin solid"><div class="">to fallback on</div></div></div>
    
    
  - HTML.
- Although it probably won't be perfect.

### Trees

Trees are rendered as:
- The head element
- > followed by
- a list of the child elements.

<details><summary>Trees can be made foldable:</summary>

- The head element
- > is the summary
- <details><summary>and the children...</summary>
  
  - **are the details.**
  </details>
  
  
</details>



### Tables

There is a special case carved out for Markdown syntax tables.

Header|cells    |[must be]|bold.
------|---------|---------|-----------------
Rows  |[must be]|single   |line.
[Only]|then     |**we get**   |a Markdown table.

<div>
 <table class="framed">
  <tr class=""><td class=""><div class=""><b>Tables</b></div></td>
   <td class=""><div class=""><b>that meet</b></div></td>
   <td class="">
    <div style="border:thin solid"><div class=""><b>neither</b></div></div>
   </td><td class=""><div class=""><b>of:</b></div></td>
  </tr>
  <tr class="">
   <td class="">
    <div style="border:thin solid">
     <div class=""><b>Markdown's native</b></div>
    </div>
   </td><td class=""><div class="">restrictions,</div></td>
   <td class=""><div class="">special cases:</div></td>
   <td class=""><pre class="" style="font-family: monospace">hlist
                                                             vlist</pre>
   </td>
  </tr>
  <tr class=""><td class=""><div class="">End up</div></td>
   <td class=""><div class="">as either</div></td>
   <td class=""><div class="">of the fallbacks:</div></td>
   <td class="">
    <pre class="" style="font-family: monospace">printbox-text
                                                 printbox-html
    </pre>
   </td>
  </tr>
 </table>
</div>



