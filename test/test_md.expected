Test default:
> root
- > child 1
- `child 2`
- line 1<br>
  line 2<br>
  line 3
- - a row 1
  - a row 2.1<br>
    a row 2.2
  - a row 3
- - b row 1
    > ---
  - b row 2.1<br>
    b row 2.2
    > ---
  - b row 3
- > - c row 1
  >   > ---
  > - c row 2.1<br>
  >   c row 2.2
  >   > ---
  > - c row 3
- > 
  > - > header 3
  >   - > subchild 3
- 
  - > header 4
    - \<returns\>
      - `<nothing>`
    - & \*\*subchild\*\* 4
- > `header 5`
  > - ```
  >   subchild 5
  >     body 5
  >       subbody 5
  >   	one tab end of sub 5
  >   end of 5
  >   ```
  >   
- > > ```
  > > a    │looooooooooooooooooooooooo
  > >      │oonng
  > > ─────┼──────────────────────────
  > > bx   │          ┌─┬─┐
  > >      │          │x│y│
  > >      │          ├─┼─┤
  > >      │          │1│2│
  > >      │          └─┴─┘
  > > ─────┼──────────────────────────
  > >      │
  > >      │          x │y
  > >   ?  │          ──┼──
  > >      │          10│20
  > >      │
  > > ```
  > > 
- header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |cell 2.3
- > header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  > -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  > cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  > <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |cell 2.3

Test uniform unfolded:

<span style="border:thin solid"><span style="white-space: pre">root</span></span>
- <span style="border:thin solid"><span style="white-space: pre">child 1</span></span>
- <span style="font-family: monospace;white-space: pre">child 2</span>
- <div style="white-space: pre">line 1
  line 2
  line 3</div>
- <span style="white-space: pre">a row 1</span><br>
  <div style="white-space: pre">a row 2.1
  a row 2.2</div><br>
  <span style="white-space: pre">a row 3</span>
- <div style="border-bottom:thin solid">
  <span style="white-space: pre">b row 1</span></div>
  <div style="border-bottom:thin solid">
  <div style="white-space: pre">b row 2.1
  b row 2.2</div></div>
  <span style="white-space: pre">b row 3</span>
- <div style="border:thin solid">
  
  <div style="border-bottom:thin solid">
  <span style="white-space: pre">c row 1</span></div>
  <div style="border-bottom:thin solid">
  <div style="white-space: pre">c row 2.1
  c row 2.2</div></div>
  <span style="white-space: pre">c row 3</span>
  </div>
- <div style="border:thin solid">
  
  
  - <span style="border:thin solid"><span style="white-space: pre">header 3</span></span>
    - <span style="border:thin solid"><span style="white-space: pre">subchild 3</span></span>
  </div>
- 
  - <span style="border:thin solid"><span style="white-space: pre">header 4</span></span>
    - <span style="white-space: pre">\<returns\></span>
      - <span style="font-family: monospace;white-space: pre">\<nothing\></span>
    - <span style="white-space: pre">& \*\*subchild\*\* 4</span>
- <div style="border:thin solid">
  
  <span style="font-family: monospace;white-space: pre">header 5</span>
  - <div style="font-family: monospace">
    <div style="white-space: pre">subchild 5
     &nbsp;body 5
     &nbsp;  subbody 5
     &nbsp; one tab end of sub 5
    end of 5
    </div></div>
  </div>
- <div style="border:thin solid">
  
  <div style="border:thin solid">
  
  <div>
   <table class="framed">
    <tr class=""><td class=""><span class="">a</span></td>
     <td class=""><span class="">looooooooooooooooooooooooo
                                 oonng</span></td>
    </tr>
    <tr class=""><td class=""><span class="">bx</span></td>
     <td class="">
      <div class="center">
       <div style="border:thin solid">
        <table class="framed">
         <tr class=""><td class=""><span class="">x</span></td>
          <td class=""><span class="">y</span></td>
         </tr>
         <tr class=""><td class=""><span class="">1</span></td>
          <td class=""><span class="">2</span></td>
         </tr>
        </table>
       </div>
      </div>
     </td>
    </tr>
    <tr class=""><td class=""><span class="">?</span></td>
     <td class="">
      <div class="center">
       <table class="framed">
        <tr class=""><td class=""><span class="">x</span></td>
         <td class=""><span class="">y</span></td>
        </tr>
        <tr class=""><td class=""><span class="">10</span></td>
         <td class=""><span class="">20</span></td>
        </tr>
       </table>
      </div>
     </td>
    </tr>
   </table>
  </div>
  </div>
  </div>
- <span style="white-space: pre">header 1</span>                                       |<span style="white-space: pre">header 2</span>                                       |<span style="border:thin solid"><span style="white-space: pre">header 3</span></span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  <span style="white-space: pre">cell 1.1</span>                                       |<span style="border:thin solid"><span style="white-space: pre">cell 1.2</span></span>|<span style="white-space: pre">cell 1.3</span>
  <span style="border:thin solid"><span style="white-space: pre">cell 2.1</span></span>|<span style="white-space: pre">cell 2.2</span>                                       |<span style="white-space: pre">cell 2.3</span>
- <div style="border:thin solid">
  
  <span style="white-space: pre">header 1</span>                                       |<span style="white-space: pre">header 2</span>                                       |<span style="border:thin solid"><span style="white-space: pre">header 3</span></span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  <span style="white-space: pre">cell 1.1</span>                                       |<span style="border:thin solid"><span style="white-space: pre">cell 1.2</span></span>|<span style="white-space: pre">cell 1.3</span>
  <span style="border:thin solid"><span style="white-space: pre">cell 2.1</span></span>|<span style="white-space: pre">cell 2.2</span>                                       |<span style="white-space: pre">cell 2.3</span>
  </div>

Test foldable:
<details><summary><span style="border:thin solid">root</span></summary>

- > child 1
- `child 2`
- line 1<br>
  line 2<br>
  line 3
- - a row 1
  - a row 2.1<br>
    a row 2.2
  - a row 3
- - b row 1
    > ---
  - b row 2.1<br>
    b row 2.2
    > ---
  - b row 3
- > - c row 1
  >   > ---
  > - c row 2.1<br>
  >   c row 2.2
  >   > ---
  > - c row 3
- > <details><summary></summary>
  > 
  > - <details><summary><span style="border:thin solid">header 3</span></summary>
  >   
  >   - > subchild 3
  >   </details>
  > </details>
- <details><summary></summary>
  
  - <details><summary><span style="border:thin solid">header 4</span></summary>
    
    - <details><summary>&lt;returns&gt;</summary>
      
      - `<nothing>`
      </details>
    - & \*\*subchild\*\* 4
    </details>
  </details>
- > <details><summary><span style="font-family: monospace">header 5</span></summary>
  > 
  > - ```
  >   subchild 5
  >     body 5
  >       subbody 5
  >   	one tab end of sub 5
  >   end of 5
  >   ```
  >   
  > </details>
- > > ```
  > > a    │looooooooooooooooooooooooo
  > >      │oonng
  > > ─────┼──────────────────────────
  > > bx   │          ┌─┬─┐
  > >      │          │x│y│
  > >      │          ├─┼─┤
  > >      │          │1│2│
  > >      │          └─┴─┘
  > > ─────┼──────────────────────────
  > >      │
  > >      │          x │y
  > >   ?  │          ──┼──
  > >      │          10│20
  > >      │
  > > ```
  > > 
- header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |cell 2.3
- > header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  > -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  > cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  > <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |cell 2.3
</details>

Test uniform tab=2, text tables:
<details><summary><span style="border:thin solid"><span style="white-space: pre">root</span></span></summary>

- <span style="border:thin solid"><span style="white-space: pre">child 1</span></span>
- <span style="font-family: monospace;white-space: pre">child 2</span>
- <div style="white-space: pre">line 1
  line 2
  line 3</div>
- <span style="white-space: pre">a row 1</span><br>
  <div style="white-space: pre">a row 2.1
  a row 2.2</div><br>
  <span style="white-space: pre">a row 3</span>
- <div style="border-bottom:thin solid">
  <span style="white-space: pre">b row 1</span></div>
  <div style="border-bottom:thin solid">
  <div style="white-space: pre">b row 2.1
  b row 2.2</div></div>
  <span style="white-space: pre">b row 3</span>
- <div style="border:thin solid">
  
  <div style="border-bottom:thin solid">
  <span style="white-space: pre">c row 1</span></div>
  <div style="border-bottom:thin solid">
  <div style="white-space: pre">c row 2.1
  c row 2.2</div></div>
  <span style="white-space: pre">c row 3</span>
  </div>
- <div style="border:thin solid">
  
  <details><summary></summary>
  
  - <details><summary><span style="border:thin solid"><span style="white-space: pre">header 3</span></span></summary>
    
    - <span style="border:thin solid"><span style="white-space: pre">subchild 3</span></span>
    </details>
  </details>
  </div>
- <details><summary></summary>
  
  - <details><summary><span style="border:thin solid"><span style="white-space: pre">header 4</span></span></summary>
    
    - <details><summary><span style="white-space: pre">&lt;returns&gt;</span></summary>
      
      - <span style="font-family: monospace;white-space: pre">\<nothing\></span>
      </details>
    - <span style="white-space: pre">& \*\*subchild\*\* 4</span>
    </details>
  </details>
- <div style="border:thin solid">
  
  <details><summary><span style="font-family: monospace;white-space: pre">header 5</span></summary>
  
  - <div style="font-family: monospace">
    <div style="white-space: pre">subchild 5
     &nbsp;body 5
     &nbsp;  subbody 5
     one tab end of sub 5
    end of 5
    </div></div>
  </details>
  </div>
- <div style="border:thin solid">
  
  <div style="border:thin solid">
  
  <div style="font-family: monospace">
  <div style="white-space: pre">a &nbsp;  │looooooooooooooooooooooooo
   &nbsp;  &nbsp;│oonng
  ─────┼──────────────────────────
  bx &nbsp; │ &nbsp;  &nbsp;  &nbsp;  ┌─┬─┐
   &nbsp;  &nbsp;│ &nbsp;  &nbsp;  &nbsp;  │x│y│
   &nbsp;  &nbsp;│ &nbsp;  &nbsp;  &nbsp;  ├─┼─┤
   &nbsp;  &nbsp;│ &nbsp;  &nbsp;  &nbsp;  │1│2│
   &nbsp;  &nbsp;│ &nbsp;  &nbsp;  &nbsp;  └─┴─┘
  ─────┼──────────────────────────
   &nbsp;  &nbsp;│
   &nbsp;  &nbsp;│ &nbsp;  &nbsp;  &nbsp;  x │y
   &nbsp;? &nbsp;│ &nbsp;  &nbsp;  &nbsp;  ──┼──
   &nbsp;  &nbsp;│ &nbsp;  &nbsp;  &nbsp;  10│20
   &nbsp;  &nbsp;│
  </div></div>
  </div>
  </div>
- <span style="white-space: pre">header 1</span>                                       |<span style="white-space: pre">header 2</span>                                       |<span style="border:thin solid"><span style="white-space: pre">header 3</span></span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  <span style="white-space: pre">cell 1.1</span>                                       |<span style="border:thin solid"><span style="white-space: pre">cell 1.2</span></span>|<span style="white-space: pre">cell 1.3</span>
  <span style="border:thin solid"><span style="white-space: pre">cell 2.1</span></span>|<span style="white-space: pre">cell 2.2</span>                                       |<span style="white-space: pre">cell 2.3</span>
- <div style="border:thin solid">
  
  <span style="white-space: pre">header 1</span>                                       |<span style="white-space: pre">header 2</span>                                       |<span style="border:thin solid"><span style="white-space: pre">header 3</span></span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  <span style="white-space: pre">cell 1.1</span>                                       |<span style="border:thin solid"><span style="white-space: pre">cell 1.2</span></span>|<span style="white-space: pre">cell 1.3</span>
  <span style="border:thin solid"><span style="white-space: pre">cell 2.1</span></span>|<span style="white-space: pre">cell 2.2</span>                                       |<span style="white-space: pre">cell 2.3</span>
  </div>
</details>

Test single quote tab=2, text tables:
<details><summary><span style="border:thin solid"><span style="white-space: pre">root</span></span></summary>

- <span style="border:thin solid"><span style="white-space: pre">child 1</span></span>
- <span style="font-family: monospace;white-space: pre">child 2</span>
- <div style="white-space: pre">line 1
  line 2
  line 3</div>
- <span style="white-space: pre">a row 1</span><br>
  <div style="white-space: pre">a row 2.1
  a row 2.2</div><br>
  <span style="white-space: pre">a row 3</span>
- <div style="border-bottom:thin solid">
  <span style="white-space: pre">b row 1</span></div>
  <div style="border-bottom:thin solid">
  <div style="white-space: pre">b row 2.1
  b row 2.2</div></div>
  <span style="white-space: pre">b row 3</span>
- <div style="border:thin solid">
  
  <div style="border-bottom:thin solid">
  <span style="white-space: pre">c row 1</span></div>
  <div style="border-bottom:thin solid">
  <div style="white-space: pre">c row 2.1
  c row 2.2</div></div>
  <span style="white-space: pre">c row 3</span>
  </div>
- <div style="border:thin solid">
  
  <details><summary></summary>
  
  - <details><summary><span style="border:thin solid"><span style="white-space: pre">header 3</span></span></summary>
    
    - <span style="border:thin solid"><span style="white-space: pre">subchild 3</span></span>
    </details>
  </details>
  </div>
- <details><summary></summary>
  
  - <details><summary><span style="border:thin solid"><span style="white-space: pre">header 4</span></span></summary>
    
    - <details><summary><span style="white-space: pre">&lt;returns&gt;</span></summary>
      
      - <span style="font-family: monospace;white-space: pre">\<nothing\></span>
      </details>
    - <span style="white-space: pre">& \*\*subchild\*\* 4</span>
    </details>
  </details>
- <div style="border:thin solid">
  
  <details><summary><span style="font-family: monospace;white-space: pre">header 5</span></summary>
  
  - `subchild 5`<br>
     `body 5`<br>
     &nbsp; `subbody 5`<br>
    &nbsp;`one tab end of sub 5`<br>
    `end of 5`
  </details>
  </div>
- <div style="border:thin solid">
  
  <div style="border:thin solid">
  
  `a    │looooooooooooooooooooooooo`<br>
   &nbsp; &nbsp;`│oonng`<br>
  `─────┼──────────────────────────`<br>
  `bx   │          ┌─┬─┐`<br>
   &nbsp; &nbsp;`│          │x│y│`<br>
   &nbsp; &nbsp;`│          ├─┼─┤`<br>
   &nbsp; &nbsp;`│          │1│2│`<br>
   &nbsp; &nbsp;`│          └─┴─┘`<br>
  `─────┼──────────────────────────`<br>
   &nbsp; &nbsp;`│`<br>
   &nbsp; &nbsp;`│          x │y`<br>
   `?  │          ──┼──`<br>
   &nbsp; &nbsp;`│          10│20`<br>
   &nbsp; &nbsp;`│`
  </div>
  </div>
- <span style="white-space: pre">header 1</span>                                       |<span style="white-space: pre">header 2</span>                                       |<span style="border:thin solid"><span style="white-space: pre">header 3</span></span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  <span style="white-space: pre">cell 1.1</span>                                       |<span style="border:thin solid"><span style="white-space: pre">cell 1.2</span></span>|<span style="white-space: pre">cell 1.3</span>
  <span style="border:thin solid"><span style="white-space: pre">cell 2.1</span></span>|<span style="white-space: pre">cell 2.2</span>                                       |<span style="white-space: pre">cell 2.3</span>
- <div style="border:thin solid">
  
  <span style="white-space: pre">header 1</span>                                       |<span style="white-space: pre">header 2</span>                                       |<span style="border:thin solid"><span style="white-space: pre">header 3</span></span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  <span style="white-space: pre">cell 1.1</span>                                       |<span style="border:thin solid"><span style="white-space: pre">cell 1.2</span></span>|<span style="white-space: pre">cell 1.3</span>
  <span style="border:thin solid"><span style="white-space: pre">cell 2.1</span></span>|<span style="white-space: pre">cell 2.2</span>                                       |<span style="white-space: pre">cell 2.3</span>
  </div>
</details>

The end.
