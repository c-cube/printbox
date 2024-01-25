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
  - > a row 3
- - b row 1
    > ---
  - b row 2.1<br>
    b row 2.2
    > ---
  - **b row 3**
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; > a longiiish column 3 &nbsp; a longiiish column 4
- b longiiish column 1 | **b longiiish column 2** | b longiiish column 3 | > b longiiish column 4
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
- header 1  |header 2  |[header 3]
  ----------|----------|----------
  cell 1.1  |[cell 1.2]|cell 1.3
  [cell 2.1]|cell 2.2  |<b>cell 2.3</b>
- > header 1  |header 2  |[header 3]
  > ----------|----------|----------
  > cell 1.1  |[cell 1.2]|cell 1.3
  > [cell 2.1]|cell 2.2  |<b>cell 2.3</b>

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
  <span style="border:thin solid">a row 3</span>
- <div style="border-bottom:thin solid">
  b row 1</div>
  <div style="border-bottom:thin solid">
  b row 2.1<br>
  b row 2.2</div>
  **b row 3**
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; <span style="border:thin solid">a longiiish column 3</span> &nbsp; a longiiish column 4
- <span style="border-right: thin solid">b longiiish column 1 </span> <span style="border-right: thin solid">**b longiiish column 2** </span> <span style="border-right: thin solid">b longiiish column 3 </span> <span style="border:thin solid">b longiiish column 4</span>
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
    · body 5<br>
    · · subbody 5<br>
    · · one tab end of sub 5<br>
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
- header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |<b>cell 2.3</b>
- <div style="border:thin solid">
  
  header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |<b>cell 2.3</b>
  </div>

Test foldable:
<details><summary>[root]</summary>

- > child 1
- `child 2`
- line 1<br>
  line 2<br>
  line 3
- - a row 1
  - a row 2.1<br>
    a row 2.2
  - > a row 3
- - b row 1
    > ---
  - b row 2.1<br>
    b row 2.2
    > ---
  - **b row 3**
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; > a longiiish column 3 &nbsp; a longiiish column 4
- b longiiish column 1 | **b longiiish column 2** | b longiiish column 3 | > b longiiish column 4
- > - c row 1
  >   > ---
  > - c row 2.1<br>
  >   c row 2.2
  >   > ---
  > - c row 3
- > <details><summary></summary>
  > 
  > - <details><summary>[header 3]</summary>
  >   
  >   - > subchild 3
  >   </details>
  > </details>
- <details><summary></summary>
  
  - <details><summary>[header 4]</summary>
    
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
- header 1  |header 2  |[header 3]
  ----------|----------|----------
  cell 1.1  |[cell 1.2]|cell 1.3
  [cell 2.1]|cell 2.2  |<b>cell 2.3</b>
- > header 1  |header 2  |[header 3]
  > ----------|----------|----------
  > cell 1.1  |[cell 1.2]|cell 1.3
  > [cell 2.1]|cell 2.2  |<b>cell 2.3</b>
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
  <span style="border:thin solid">a row 3</span>
- <div style="border-bottom:thin solid">
  b row 1</div>
  <div style="border-bottom:thin solid">
  b row 2.1<br>
  b row 2.2</div>
  **b row 3**
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; <span style="border:thin solid">a longiiish column 3</span> &nbsp; a longiiish column 4
- <span style="border-right: thin solid">b longiiish column 1 </span> <span style="border-right: thin solid">**b longiiish column 2** </span> <span style="border-right: thin solid">b longiiish column 3 </span> <span style="border:thin solid">b longiiish column 4</span>
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
    · body 5<br>
    · · subbody 5<br>
    · one tab end of sub 5<br>
    end of 5
    </div>
  </details>
  </div>
- <div style="border:thin solid">
  
  <div style="border:thin solid">
  
  <div style="font-family: monospace">
  a ·· │looooooooooooooooooooooooo<br>
  · ·· │oonng<br>
  ─────┼──────────────────────────<br>
  bx · │ · · · ·· ┌─┬─┐<br>
  · ·· │ · · · ·· │x│y│<br>
  · ·· │ · · · ·· ├─┼─┤<br>
  · ·· │ · · · ·· │1│2│<br>
  · ·· │ · · · ·· └─┴─┘<br>
  ─────┼──────────────────────────<br>
  · ·· │<br>
  · ·· │ · · · ·· x │y<br>
  · ?· │ · · · ·· ──┼──<br>
  · ·· │ · · · ·· 10│20<br>
  · ·· │
  </div>
  </div>
  </div>
- header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |<b>cell 2.3</b>
- <div style="border:thin solid">
  
  header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |<b>cell 2.3</b>
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
  <span style="border:thin solid">a row 3</span>
- <div style="border-bottom:thin solid">
  b row 1</div>
  <div style="border-bottom:thin solid">
  b row 2.1<br>
  b row 2.2</div>
  **b row 3**
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; <span style="border:thin solid">a longiiish column 3</span> &nbsp; a longiiish column 4
- <span style="border-right: thin solid">b longiiish column 1 </span> <span style="border-right: thin solid">**b longiiish column 2** </span> <span style="border-right: thin solid">b longiiish column 3 </span> <span style="border:thin solid">b longiiish column 4</span>
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
    `· body 5`<br>
    `· · subbody 5`<br>
    `· one tab end of sub 5`<br>
    `end of 5`
  </details>
  </div>
- <div style="border:thin solid">
  
  <div style="border:thin solid">
  
  `a ·· │looooooooooooooooooooooooo`<br>
  `· ·· │oonng`<br>
  `─────┼──────────────────────────`<br>
  `bx · │ · · · ·· ┌─┬─┐`<br>
  `· ·· │ · · · ·· │x│y│`<br>
  `· ·· │ · · · ·· ├─┼─┤`<br>
  `· ·· │ · · · ·· │1│2│`<br>
  `· ·· │ · · · ·· └─┴─┘`<br>
  `─────┼──────────────────────────`<br>
  `· ·· │`<br>
  `· ·· │ · · · ·· x │y`<br>
  `· ?· │ · · · ·· ──┼──`<br>
  `· ·· │ · · · ·· 10│20`<br>
  `· ·· │`
  </div>
  </div>
- header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |<b>cell 2.3</b>
- <div style="border:thin solid">
  
  header 1                                       |header 2                                       |<span style="border:thin solid">header 3</span>
  -----------------------------------------------|-----------------------------------------------|-----------------------------------------------
  cell 1.1                                       |<span style="border:thin solid">cell 1.2</span>|cell 1.3
  <span style="border:thin solid">cell 2.1</span>|cell 2.2                                       |<b>cell 2.3</b>
  </div>
</details>

The end.
