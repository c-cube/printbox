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
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; [a longiiish column 3] &nbsp; a longiiish column 4
- b longiiish column 1 | **b longiiish column 2** | b longiiish column 3 | [b longiiish column 4]
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
  > - 
  >   ```
  >   subchild 5
  >     body 5
  >       subbody 5
  >   	one tab end of sub 5
  >   end of 5
  >   ```
  >   
- > > 
  > > ```
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
  > > 
  > > 
- header 1  |header 2  |[header 3]
  ----------|----------|----------
  cell 1.1  |[cell 1.2]|cell 1.3
  [cell 2.1]|cell 2.2  |**cell 2.3**
- > header 1  |header 2  |[header 3]
  > ----------|----------|----------
  > cell 1.1  |[cell 1.2]|cell 1.3
  > [cell 2.1]|cell 2.2  |**cell 2.3**

Test uniform unfolded (broken because of #34):

<div><div style="border:thin solid"><span class="">root</span></div></div>


- <div><div style="border:thin solid"><span class="">child 1</span></div>
  </div>
  
  
- `child 2`
- line 1<br>
  line 2<br>
  line 3
- a row 1<br>
  
  a row 2.1<br>
  a row 2.2<br>
  
  <div><div style="border:thin solid"><span class="">a row 3</span></div>
  </div>
  
  
- b row 1<br>
  > ---
  b row 2.1<br>
  b row 2.2<br>
  > ---
  **b row 3**
- <div>
   <table class="non-framed">
    <tr class="">
     <td class=""><span class=""><b>a longiiish column 1</b></span></td>
     <td class=""><span class="">a longiiish column 2</span></td>
     <td class="">
      <div style="border:thin solid"><span class="">a longiiish column 3</span>
      </div>
     </td><td class=""><span class="">a longiiish column 4</span></td>
    </tr>
   </table>
  </div>
  
  
- <div>
   <table class="framed">
    <tr class=""><td class=""><span class="">b longiiish column 1</span></td>
     <td class=""><span class=""><b>b longiiish column 2</b></span></td>
     <td class=""><span class="">b longiiish column 3</span></td>
     <td class="">
      <div style="border:thin solid"><span class="">b longiiish column 4</span>
      </div>
     </td>
    </tr>
   </table>
  </div>
  
  
- <div>
   <div style="border:thin solid">
    <table class="framed">
     <tr class=""><td class=""><span class="">c row 1</span></td></tr>
     <tr class=""><td class=""><span class="">c row 2.1c row 2.2</span></td>
     </tr><tr class=""><td class=""><span class="">c row 3</span></td></tr>
    </table>
   </div>
  </div>
  
  
- <div>
   <div style="border:thin solid">
    <div><div></div>
     <ul>
      <li>
       <div>
        <div style="border:thin solid"><span class="">header 3</span></div>
        <ul>
         <li>
          <div style="border:thin solid"><span class="">subchild 3</span>
          </div>
         </li>
        </ul>
       </div>
      </li>
     </ul>
    </div>
   </div>
  </div>
  
  
- 
  - <div><div style="border:thin solid"><span class="">header 4</span></div>
    </div>
    
    
    - \<returns\>
      - `<nothing>`
    - & \*\*subchild\*\* 4
- <div>
   <div style="border:thin solid">
    <div>
     <pre><span class="" style="font-family: monospace">header 5</span></pre>
     <ul>
      <li>
       <pre>
        <span class="" style="font-family: monospace">subchild 5  body 5
             subbody 5	one tab end of sub 5end of 5
        </span>
       </pre>
      </li>
     </ul>
    </div>
   </div>
  </div>
  
  
- <div>
   <div style="border:thin solid">
    <div style="border:thin solid">
     <table class="framed">
      <tr class=""><td class=""><span class="">a</span></td>
       <td class=""><span class="">looooooooooooooooooooooooo
                                   oonng</span>
       </td>
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
  
  
- <div>
   <table class="framed">
    <tr class=""><td class=""><span class=""><b>header 1</b></span></td>
     <td class=""><span class=""><b>header 2</b></span></td>
     <td class="">
      <div style="border:thin solid"><span class=""><b>header 3</b></span>
      </div>
     </td>
    </tr>
    <tr class=""><td class=""><span class="">cell 1.1</span></td>
     <td class="">
      <div style="border:thin solid"><span class="">cell 1.2</span></div>
     </td><td class=""><span class="">cell 1.3</span></td>
    </tr>
    <tr class="">
     <td class="">
      <div style="border:thin solid"><span class="">cell 2.1</span></div>
     </td><td class=""><span class="">cell 2.2</span></td>
     <td class=""><span class=""><b>cell 2.3</b></span></td>
    </tr>
   </table>
  </div>
  
  
- <div>
   <div style="border:thin solid">
    <table class="framed">
     <tr class=""><td class=""><span class=""><b>header 1</b></span></td>
      <td class=""><span class=""><b>header 2</b></span></td>
      <td class="">
       <div style="border:thin solid"><span class=""><b>header 3</b></span>
       </div>
      </td>
     </tr>
     <tr class=""><td class=""><span class="">cell 1.1</span></td>
      <td class="">
       <div style="border:thin solid"><span class="">cell 1.2</span></div>
      </td><td class=""><span class="">cell 1.3</span></td>
     </tr>
     <tr class="">
      <td class="">
       <div style="border:thin solid"><span class="">cell 2.1</span></div>
      </td><td class=""><span class="">cell 2.2</span></td>
      <td class=""><span class=""><b>cell 2.3</b></span></td>
     </tr>
    </table>
   </div>
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
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; [a longiiish column 3] &nbsp; a longiiish column 4
- b longiiish column 1 | **b longiiish column 2** | b longiiish column 3 | [b longiiish column 4]
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
  >   
  >   
  > </details>
  > 
  > 
- <details><summary></summary>
  
  - <details><summary>[header 4]</summary>
    
    - <details><summary>&lt;returns&gt;</summary>
      
      - `<nothing>`
      </details>
      
      
    - & \*\*subchild\*\* 4
    </details>
    
    
  </details>
  
  
- > <details><summary><code>header 5</code></summary>
  > 
  > - 
  >   ```
  >   subchild 5
  >     body 5
  >       subbody 5
  >   	one tab end of sub 5
  >   end of 5
  >   ```
  >   
  > </details>
  > 
  > 
- > > 
  > > ```
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
  > > 
  > > 
- header 1  |header 2  |[header 3]
  ----------|----------|----------
  cell 1.1  |[cell 1.2]|cell 1.3
  [cell 2.1]|cell 2.2  |**cell 2.3**
- > header 1  |header 2  |[header 3]
  > ----------|----------|----------
  > cell 1.1  |[cell 1.2]|cell 1.3
  > [cell 2.1]|cell 2.2  |**cell 2.3**
</details>



Test uniform tab=2, text tables:
<details><summary><code>┌────┐<br>
│root│<br>
└────┘</code></summary>

- 
  ```
  ┌───────┐
  │child 1│
  └───────┘
  ```
  
- `child 2`
- line 1<br>
  line 2<br>
  line 3
- a row 1<br>
  
  a row 2.1<br>
  a row 2.2<br>
  
  
  ```
  ┌───────┐
  │a row 3│
  └───────┘
  ```
  
- b row 1<br>
  > ---
  b row 2.1<br>
  b row 2.2<br>
  > ---
  **b row 3**
- 
  ```
  [1ma longiiish column 1[0ma longiiish column 2┌────────────────────┐a longiiish column 4
                                          │a longiiish column 3│
                                          └────────────────────┘
  ```
  
  
  
- 
  ```
  b longiiish column 1│[1mb longiiish column 2[0m│b longiiish column 3│┌────────────────────┐
                      │                    │                    ││b longiiish column 4│
                      │                    │                    │└────────────────────┘
  ```
  
  
  
- 
  ```
  ┌─────────┐
  │c row 1  │
  ├─────────┤
  │c row 2.1│
  │c row 2.2│
  ├─────────┤
  │c row 3  │
  └─────────┘
  ```
  
- 
  ```
  ┌──────────────────┐
  │──┬────────┐      │
  │  │header 3│      │
  │  ├────────┘      │
  │  └─┬──────────┐  │
  │    │subchild 3│  │
  │    └──────────┘  │
  └──────────────────┘
  ```
  
- <details><summary></summary>
  
  - <details><summary><code>┌────────┐<br>
    │header 4│<br>
    └────────┘</code></summary>
    
    - <details><summary>&lt;returns&gt;</summary>
      
      - `<nothing>`
      </details>
      
      
    - & \*\*subchild\*\* 4
    </details>
    
    
  </details>
  
  
- 
  ```
  ┌───────────────────────┐
  │header 5               │
  │└─subchild 5           │
  │    body 5             │
  │      subbody 5        │
  │  	one tab end of sub 5 │
  │  end of 5             │
  └───────────────────────┘
  ```
  
- 
  ```
  ┌──────────────────────────────────┐
  │┌─────┬──────────────────────────┐│
  ││a    │looooooooooooooooooooooooo││
  ││     │oonng                     ││
  │├─────┼──────────────────────────┤│
  ││bx   │          ┌─┬─┐           ││
  ││     │          │x│y│           ││
  ││     │          ├─┼─┤           ││
  ││     │          │1│2│           ││
  ││     │          └─┴─┘           ││
  │├─────┼──────────────────────────┤│
  ││     │                          ││
  ││     │          x │y            ││
  ││  ?  │          ──┼──           ││
  ││     │          10│20           ││
  ││     │                          ││
  │└─────┴──────────────────────────┘│
  └──────────────────────────────────┘
  ```
  
- 
  ```
  [1mheader 1[0m  │[1mheader 2[0m  │┌────────┐
            │          ││[1mheader 3[0m│
            │          │└────────┘
  ──────────┼──────────┼──────────
  cell 1.1  │┌────────┐│cell 1.3
            ││cell 1.2││
            │└────────┘│
  ──────────┼──────────┼──────────
  ┌────────┐│cell 2.2  │[1mcell 2.3[0m
  │cell 2.1││          │
  └────────┘│          │
  ```
  
  
  
- 
  ```
  ┌──────────┬──────────┬──────────┐
  │[1mheader 1[0m  │[1mheader 2[0m  │┌────────┐│
  │          │          ││[1mheader 3[0m││
  │          │          │└────────┘│
  ├──────────┼──────────┼──────────┤
  │cell 1.1  │┌────────┐│cell 1.3  │
  │          ││cell 1.2││          │
  │          │└────────┘│          │
  ├──────────┼──────────┼──────────┤
  │┌────────┐│cell 2.2  │[1mcell 2.3[0m  │
  ││cell 2.1││          │          │
  │└────────┘│          │          │
  └──────────┴──────────┴──────────┘
  ```
  
</details>



Test single quote tab=2, text tables:
<details><summary><code>┌────┐<br>
│root│<br>
└────┘</code></summary>

- `┌───────┐`<br>
  `│child 1│`<br>
  `└───────┘`
- `child 2`
- line 1<br>
  line 2<br>
  line 3
- a row 1<br>
  
  a row 2.1<br>
  a row 2.2<br>
  
  `┌───────┐`<br>
  `│a row 3│`<br>
  `└───────┘`
- b row 1<br>
  > ---
  b row 2.1<br>
  b row 2.2<br>
  > ---
  **b row 3**
- `[1ma longiiish column 1[0ma longiiish column 2┌────────────────────┐a longiiish column 4`<br>
  `· · · · · · · · · · · · · · · · · · · · │a longiiish column 3│`<br>
  `· · · · · · · · · · · · · · · · · · · · └────────────────────┘`
  
  
- `b longiiish column 1│[1mb longiiish column 2[0m│b longiiish column 3│┌────────────────────┐`<br>
  `· · · · · · · · · · │ · · · · · · · · ·· │ · · · · · · · · ·· ││b longiiish column 4│`<br>
  `· · · · · · · · · · │ · · · · · · · · ·· │ · · · · · · · · ·· │└────────────────────┘`
  
  
- `┌─────────┐`<br>
  `│c row 1· │`<br>
  `├─────────┤`<br>
  `│c row 2.1│`<br>
  `│c row 2.2│`<br>
  `├─────────┤`<br>
  `│c row 3· │`<br>
  `└─────────┘`
- `┌──────────────────┐`<br>
  `│──┬────────┐ · ·· │`<br>
  `│· │header 3│ · ·· │`<br>
  `│· ├────────┘ · ·· │`<br>
  `│· └─┬──────────┐· │`<br>
  `│ ·· │subchild 3│· │`<br>
  `│ ·· └──────────┘· │`<br>
  `└──────────────────┘`
- <details><summary></summary>
  
  - <details><summary><code>┌────────┐<br>
    │header 4│<br>
    └────────┘</code></summary>
    
    - <details><summary>&lt;returns&gt;</summary>
      
      - `<nothing>`
      </details>
      
      
    - & \*\*subchild\*\* 4
    </details>
    
    
  </details>
  
  
- `┌───────────────────────┐`<br>
  `│header 5 · · · · · · · │`<br>
  `│└─subchild 5 · · · · · │`<br>
  `│ ·· body 5 · · · · · · │`<br>
  `│ · ·· subbody 5 · · ·· │`<br>
  `│·  ·one tab end of sub 5 │`<br>
  `│· end of 5 · · · · · · │`<br>
  `└───────────────────────┘`
- `┌──────────────────────────────────┐`<br>
  `│┌─────┬──────────────────────────┐│`<br>
  `││a ·· │looooooooooooooooooooooooo││`<br>
  `││ · · │oonng · · · · · · · · · · ││`<br>
  `│├─────┼──────────────────────────┤│`<br>
  `││bx · │ · · · ·· ┌─┬─┐ · · · · · ││`<br>
  `││ · · │ · · · ·· │x│y│ · · · · · ││`<br>
  `││ · · │ · · · ·· ├─┼─┤ · · · · · ││`<br>
  `││ · · │ · · · ·· │1│2│ · · · · · ││`<br>
  `││ · · │ · · · ·· └─┴─┘ · · · · · ││`<br>
  `│├─────┼──────────────────────────┤│`<br>
  `││ · · │ · · · · · · · · · · · ·· ││`<br>
  `││ · · │ · · · ·· x │y · · · · ·· ││`<br>
  `││· ?· │ · · · ·· ──┼── · · · · · ││`<br>
  `││ · · │ · · · ·· 10│20 · · · · · ││`<br>
  `││ · · │ · · · · · · · · · · · ·· ││`<br>
  `│└─────┴──────────────────────────┘│`<br>
  `└──────────────────────────────────┘`
- `[1mheader 1[0m· │[1mheader 2[0m· │┌────────┐`<br>
  `· · · · · │ · · · ·· ││[1mheader 3[0m│`<br>
  `· · · · · │ · · · ·· │└────────┘`<br>
  `──────────┼──────────┼──────────`<br>
  `cell 1.1· │┌────────┐│cell 1.3`<br>
  `· · · · · ││cell 1.2││`<br>
  `· · · · · │└────────┘│`<br>
  `──────────┼──────────┼──────────`<br>
  `┌────────┐│cell 2.2· │[1mcell 2.3[0m`<br>
  `│cell 2.1││ · · · ·· │`<br>
  `└────────┘│ · · · ·· │`
  
  
- `┌──────────┬──────────┬──────────┐`<br>
  `│[1mheader 1[0m· │[1mheader 2[0m· │┌────────┐│`<br>
  `│ · · · ·· │ · · · ·· ││[1mheader 3[0m││`<br>
  `│ · · · ·· │ · · · ·· │└────────┘│`<br>
  `├──────────┼──────────┼──────────┤`<br>
  `│cell 1.1· │┌────────┐│cell 1.3· │`<br>
  `│ · · · ·· ││cell 1.2││ · · · ·· │`<br>
  `│ · · · ·· │└────────┘│ · · · ·· │`<br>
  `├──────────┼──────────┼──────────┤`<br>
  `│┌────────┐│cell 2.2· │[1mcell 2.3[0m· │`<br>
  `││cell 2.1││ · · · ·· │ · · · ·· │`<br>
  `│└────────┘│ · · · ·· │ · · · ·· │`<br>
  `└──────────┴──────────┴──────────┘`
</details>



The end.
