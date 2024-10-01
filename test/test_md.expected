Test default:
> root
- > child 1
- `child 2`
- line 1  
  line 2  
  line 3
- - a row 1
  - a row 2.1  
    a row 2.2
  - > a row 3
- - b row 1
    > ---
  - b row 2.1  
    b row 2.2
    > ---
  - **b row 3**
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; [a longiiish column 3] &nbsp; a longiiish column 4
- b longiiish column 1 | **b longiiish column 2** | b longiiish column 3 | [b longiiish column 4]
- > - c row 1
  >   > ---
  > - c row 2.1  
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
  ----------|----------|------------
  cell 1.1  |[cell 1.2]|cell 1.3
  [cell 2.1]|cell 2.2  |**cell 2.3**
- > header 1  |header 2  |[header 3]
  > ----------|----------|------------
  > cell 1.1  |[cell 1.2]|cell 1.3
  > [cell 2.1]|cell 2.2  |**cell 2.3**

Test uniform unfolded:


```
┌────┐
│root│
└────┘
```

- 
  ```
  ┌───────┐
  │child 1│
  └───────┘
  ```
  
- `child 2`
- line 1  
  line 2  
  line 3
- a row 1  
  
  a row 2.1  
  a row 2.2  
  
  
  ```
  ┌───────┐
  │a row 3│
  └───────┘
  ```
  
- b row 1  
  > ---
  b row 2.1  
  b row 2.2  
  > ---
  **b row 3**
- 
  ```
  a longiiish column 1a longiiish column 2┌────────────────────┐a longiiish column 4
                                          │a longiiish column 3│
                                          └────────────────────┘
  ```
  
  
  
- 
  ```
  b longiiish column 1│b longiiish column 2│b longiiish column 3│┌────────────────────┐
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
  
- 
  - 
    ```
    ┌────────┐
    │header 4│
    └────────┘
    ```
    
    - \<returns\>
      - `<nothing>`
    - & \*\*subchild\*\* 4
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
  header 1  │header 2  │┌────────┐
            │          ││header 3│
            │          │└────────┘
  ──────────┼──────────┼──────────
  cell 1.1  │┌────────┐│cell 1.3
            ││cell 1.2││
            │└────────┘│
  ──────────┼──────────┼──────────
  ┌────────┐│cell 2.2  │cell 2.3
  │cell 2.1││          │
  └────────┘│          │
  ```
  
  
  
- 
  ```
  ┌──────────┬──────────┬──────────┐
  │header 1  │header 2  │┌────────┐│
  │          │          ││header 3││
  │          │          │└────────┘│
  ├──────────┼──────────┼──────────┤
  │cell 1.1  │┌────────┐│cell 1.3  │
  │          ││cell 1.2││          │
  │          │└────────┘│          │
  ├──────────┼──────────┼──────────┤
  │┌────────┐│cell 2.2  │cell 2.3  │
  ││cell 2.1││          │          │
  │└────────┘│          │          │
  └──────────┴──────────┴──────────┘
  ```
  

Test foldable:
<details><summary>[root]</summary>

- > child 1
- `child 2`
- line 1  
  line 2  
  line 3
- - a row 1
  - a row 2.1  
    a row 2.2
  - > a row 3
- - b row 1
    > ---
  - b row 2.1  
    b row 2.2
    > ---
  - **b row 3**
- **a longiiish column 1** &nbsp; a longiiish column 2 &nbsp; [a longiiish column 3] &nbsp; a longiiish column 4
- b longiiish column 1 | **b longiiish column 2** | b longiiish column 3 | [b longiiish column 4]
- > - c row 1
  >   > ---
  > - c row 2.1  
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
  > </details>
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
  ----------|----------|------------
  cell 1.1  |[cell 1.2]|cell 1.3
  [cell 2.1]|cell 2.2  |**cell 2.3**
- > header 1  |header 2  |[header 3]
  > ----------|----------|------------
  > cell 1.1  |[cell 1.2]|cell 1.3
  > [cell 2.1]|cell 2.2  |**cell 2.3**
</details>


Test uniform tab=2:
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
- line 1  
  line 2  
  line 3
- a row 1  
  
  a row 2.1  
  a row 2.2  
  
  
  ```
  ┌───────┐
  │a row 3│
  └───────┘
  ```
  
- b row 1  
  > ---
  b row 2.1  
  b row 2.2  
  > ---
  **b row 3**
- 
  ```
  a longiiish column 1a longiiish column 2┌────────────────────┐a longiiish column 4
                                          │a longiiish column 3│
                                          └────────────────────┘
  ```
  
  
  
- 
  ```
  b longiiish column 1│b longiiish column 2│b longiiish column 3│┌────────────────────┐
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
  header 1  │header 2  │┌────────┐
            │          ││header 3│
            │          │└────────┘
  ──────────┼──────────┼──────────
  cell 1.1  │┌────────┐│cell 1.3
            ││cell 1.2││
            │└────────┘│
  ──────────┼──────────┼──────────
  ┌────────┐│cell 2.2  │cell 2.3
  │cell 2.1││          │
  └────────┘│          │
  ```
  
  
  
- 
  ```
  ┌──────────┬──────────┬──────────┐
  │header 1  │header 2  │┌────────┐│
  │          │          ││header 3││
  │          │          │└────────┘│
  ├──────────┼──────────┼──────────┤
  │cell 1.1  │┌────────┐│cell 1.3  │
  │          ││cell 1.2││          │
  │          │└────────┘│          │
  ├──────────┼──────────┼──────────┤
  │┌────────┐│cell 2.2  │cell 2.3  │
  ││cell 2.1││          │          │
  │└────────┘│          │          │
  └──────────┴──────────┴──────────┘
  ```
  
</details>


Test single quote tab=2:
<details><summary><code>┌────┐<br>
│root│<br>
└────┘</code></summary>

- `┌───────┐`  
  `│child 1│`  
  `└───────┘`
- `child 2`
- line 1  
  line 2  
  line 3
- a row 1  
  
  a row 2.1  
  a row 2.2  
  
  `┌───────┐`  
  `│a row 3│`  
  `└───────┘`
- b row 1  
  > ---
  b row 2.1  
  b row 2.2  
  > ---
  **b row 3**
- `a longiiish column 1a longiiish column 2┌────────────────────┐a longiiish column 4`  
  `· · · · · · · · · · · · · · · · · · · · │a longiiish column 3│`  
  `· · · · · · · · · · · · · · · · · · · · └────────────────────┘`
  
  
- `b longiiish column 1│b longiiish column 2│b longiiish column 3│┌────────────────────┐`  
  `· · · · · · · · · · │ · · · · · · · · ·· │ · · · · · · · · ·· ││b longiiish column 4│`  
  `· · · · · · · · · · │ · · · · · · · · ·· │ · · · · · · · · ·· │└────────────────────┘`
  
  
- `┌─────────┐`  
  `│c row 1· │`  
  `├─────────┤`  
  `│c row 2.1│`  
  `│c row 2.2│`  
  `├─────────┤`  
  `│c row 3· │`  
  `└─────────┘`
- `┌──────────────────┐`  
  `│──┬────────┐ · ·· │`  
  `│· │header 3│ · ·· │`  
  `│· ├────────┘ · ·· │`  
  `│· └─┬──────────┐· │`  
  `│ ·· │subchild 3│· │`  
  `│ ·· └──────────┘· │`  
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
  
- `┌───────────────────────┐`  
  `│header 5 · · · · · · · │`  
  `│└─subchild 5 · · · · · │`  
  `│ ·· body 5 · · · · · · │`  
  `│ · ·· subbody 5 · · ·· │`  
  `│·  ·one tab end of sub 5 │`  
  `│· end of 5 · · · · · · │`  
  `└───────────────────────┘`
- `┌──────────────────────────────────┐`  
  `│┌─────┬──────────────────────────┐│`  
  `││a ·· │looooooooooooooooooooooooo││`  
  `││ · · │oonng · · · · · · · · · · ││`  
  `│├─────┼──────────────────────────┤│`  
  `││bx · │ · · · ·· ┌─┬─┐ · · · · · ││`  
  `││ · · │ · · · ·· │x│y│ · · · · · ││`  
  `││ · · │ · · · ·· ├─┼─┤ · · · · · ││`  
  `││ · · │ · · · ·· │1│2│ · · · · · ││`  
  `││ · · │ · · · ·· └─┴─┘ · · · · · ││`  
  `│├─────┼──────────────────────────┤│`  
  `││ · · │ · · · · · · · · · · · ·· ││`  
  `││ · · │ · · · ·· x │y · · · · ·· ││`  
  `││· ?· │ · · · ·· ──┼── · · · · · ││`  
  `││ · · │ · · · ·· 10│20 · · · · · ││`  
  `││ · · │ · · · · · · · · · · · ·· ││`  
  `│└─────┴──────────────────────────┘│`  
  `└──────────────────────────────────┘`
- `header 1· │header 2· │┌────────┐`  
  `· · · · · │ · · · ·· ││header 3│`  
  `· · · · · │ · · · ·· │└────────┘`  
  `──────────┼──────────┼──────────`  
  `cell 1.1· │┌────────┐│cell 1.3`  
  `· · · · · ││cell 1.2││`  
  `· · · · · │└────────┘│`  
  `──────────┼──────────┼──────────`  
  `┌────────┐│cell 2.2· │cell 2.3`  
  `│cell 2.1││ · · · ·· │`  
  `└────────┘│ · · · ·· │`
  
  
- `┌──────────┬──────────┬──────────┐`  
  `│header 1· │header 2· │┌────────┐│`  
  `│ · · · ·· │ · · · ·· ││header 3││`  
  `│ · · · ·· │ · · · ·· │└────────┘│`  
  `├──────────┼──────────┼──────────┤`  
  `│cell 1.1· │┌────────┐│cell 1.3· │`  
  `│ · · · ·· ││cell 1.2││ · · · ·· │`  
  `│ · · · ·· │└────────┘│ · · · ·· │`  
  `├──────────┼──────────┼──────────┤`  
  `│┌────────┐│cell 2.2· │cell 2.3· │`  
  `││cell 2.1││ · · · ·· │ · · · ·· │`  
  `│└────────┘│ · · · ·· │ · · · ·· │`  
  `└──────────┴──────────┴──────────┘`
</details>


The end.
