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

Test uniform unfolded:

<span style="border:thin solid">root</span>
- <span style="border:thin solid">child 1</span>
- <span style="font-family: monospace">child 2</span>
- line 1<br>
  line 2<br>
  line 3
- a row 1<br>
  a row 2.1<br>
  a row 2.2<br>
  a row 3
- <div style="border-bottom:thin solid">
  b row 1</div>
  <div style="border-bottom:thin solid">
  b row 2.1<br>
  b row 2.2</div>
  b row 3
- <div style="border:thin solid">
  
  <div style="border-bottom:thin solid">
  c row 1</div>
  <div style="border-bottom:thin solid">
  c row 2.1<br>
  c row 2.2</div>
  c row 3
  </div>
- <div style="border:thin solid">
  
  
  - <span style="border:thin solid">header 3</span>
    - <span style="border:thin solid">subchild 3</span>
  </div>
- 
  - <span style="border:thin solid">header 4</span>
    - \<returns\>
      - <span style="font-family: monospace">\<nothing\></span>
    - & \*\*subchild\*\* 4
- <div style="border:thin solid">
  
  <span style="font-family: monospace">header 5</span>
  - <div style="font-family: monospace">
    subchild 5<br>
    &nbsp;&nbsp;body 5<br>
    &nbsp;&nbsp;&nbsp;&nbsp;subbody 5<br>
    &nbsp;&nbsp;&nbsp;&nbsp;one tab end of sub 5<br>
    end of 5
    </div>
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
</details>

Test uniform tab=2, text tables:
<details><summary><span style="border:thin solid">root</span></summary>

- <span style="border:thin solid">child 1</span>
- <span style="font-family: monospace">child 2</span>
- line 1<br>
  line 2<br>
  line 3
- a row 1<br>
  a row 2.1<br>
  a row 2.2<br>
  a row 3
- <div style="border-bottom:thin solid">
  b row 1</div>
  <div style="border-bottom:thin solid">
  b row 2.1<br>
  b row 2.2</div>
  b row 3
- <div style="border:thin solid">
  
  <div style="border-bottom:thin solid">
  c row 1</div>
  <div style="border-bottom:thin solid">
  c row 2.1<br>
  c row 2.2</div>
  c row 3
  </div>
- <div style="border:thin solid">
  
  <details><summary></summary>
  
  - <details><summary><span style="border:thin solid">header 3</span></summary>
    
    - <span style="border:thin solid">subchild 3</span>
    </details>
  </details>
  </div>
- <details><summary></summary>
  
  - <details><summary><span style="border:thin solid">header 4</span></summary>
    
    - <details><summary>&lt;returns&gt;</summary>
      
      - <span style="font-family: monospace">\<nothing\></span>
      </details>
    - & \*\*subchild\*\* 4
    </details>
  </details>
- <div style="border:thin solid">
  
  <details><summary><span style="font-family: monospace">header 5</span></summary>
  
  - <div style="font-family: monospace">
    subchild 5<br>
    &nbsp;&nbsp;body 5<br>
    &nbsp;&nbsp;&nbsp;&nbsp;subbody 5<br>
    &nbsp;&nbsp;one tab end of sub 5<br>
    end of 5
    </div>
  </details>
  </div>
- <div style="border:thin solid">
  
  <div style="border:thin solid">
  
  <div style="font-family: monospace">
  a&nbsp;&nbsp;&nbsp;&nbsp;│looooooooooooooooooooooooo<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│oonng<br>
  ─────┼──────────────────────────<br>
  bx&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;┌─┬─┐<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│x│y│<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├─┼─┤<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│1│2│<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─┴─┘<br>
  ─────┼──────────────────────────<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;x │y<br>
  &nbsp;&nbsp;?&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;──┼──<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10│20<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;│
  </div>
  </div>
  </div>
</details>

Test single quote tab=2, text tables:
<details><summary><span style="border:thin solid">root</span></summary>

- <span style="border:thin solid">child 1</span>
- <span style="font-family: monospace">child 2</span>
- line 1<br>
  line 2<br>
  line 3
- a row 1<br>
  a row 2.1<br>
  a row 2.2<br>
  a row 3
- <div style="border-bottom:thin solid">
  b row 1</div>
  <div style="border-bottom:thin solid">
  b row 2.1<br>
  b row 2.2</div>
  b row 3
- <div style="border:thin solid">
  
  <div style="border-bottom:thin solid">
  c row 1</div>
  <div style="border-bottom:thin solid">
  c row 2.1<br>
  c row 2.2</div>
  c row 3
  </div>
- <div style="border:thin solid">
  
  <details><summary></summary>
  
  - <details><summary><span style="border:thin solid">header 3</span></summary>
    
    - <span style="border:thin solid">subchild 3</span>
    </details>
  </details>
  </div>
- <details><summary></summary>
  
  - <details><summary><span style="border:thin solid">header 4</span></summary>
    
    - <details><summary>&lt;returns&gt;</summary>
      
      - <span style="font-family: monospace">\<nothing\></span>
      </details>
    - & \*\*subchild\*\* 4
    </details>
  </details>
- <div style="border:thin solid">
  
  <details><summary><span style="font-family: monospace">header 5</span></summary>
  
  - `subchild 5`<br>
    &nbsp;&nbsp;`body 5`<br>
    &nbsp;&nbsp;&nbsp;&nbsp;`subbody 5`<br>
    &nbsp;&nbsp;`one tab end of sub 5`<br>
    `end of 5`
  </details>
  </div>
- <div style="border:thin solid">
  
  <div style="border:thin solid">
  
  `a    │looooooooooooooooooooooooo`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│oonng`<br>
  `─────┼──────────────────────────`<br>
  `bx   │          ┌─┬─┐`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│          │x│y│`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│          ├─┼─┤`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│          │1│2│`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│          └─┴─┘`<br>
  `─────┼──────────────────────────`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│          x │y`<br>
  &nbsp;&nbsp;`?  │          ──┼──`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│          10│20`<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`│`
  </div>
  </div>
</details>

The end.
