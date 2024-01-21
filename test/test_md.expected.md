Test default:
> root
- > child 1
- `child 2`
- line 1<br>
  line 2<br>
  line 3
- > 
  > - > header 3
  >   - > subchild 3
- 
  - > header 4
    - subchild 4
- > `header 5`
  > - ```
  >   subchild 5
  >     body 5
  >   end of 5
  >   ```
  >   
- > child 6

Test foldable:
<details><summary><span style="border:thin solid">root</span></summary>

- > child 1
- `child 2`
- line 1<br>
  line 2<br>
  line 3
- > <details><summary></summary>
  > 
  > - <details><summary><span style="border:thin solid">header 3</span></summary>
  >   
  >   - > subchild 3
  >   </details>
  > </details>
- <details><summary></summary>
  
  - <details><summary><span style="border:thin solid">header 4</span></summary>
    
    - subchild 4
    </details>
  </details>
- > <details><summary><span style="font-family: monospace">header 5</span></summary>
  > 
  > - ```
  >   subchild 5
  >     body 5
  >   end of 5
  >   ```
  >   
  > </details>
- > child 6
</details>

Test uniform:
<details><summary><span style="border:thin solid">root</span></summary>

- <span style="border:thin solid">child 1</span>
- <span style="font-family: monospace">child 2</span>
- line 1<br>
  line 2<br>
  line 3
- <span style="border:thin solid"><details><summary></summary>
  
  - <details><summary><span style="border:thin solid">header 3</span></summary>
    
    - <span style="border:thin solid">subchild 3</span>
    </details>
  </details></span>
- <details><summary></summary>
  
  - <details><summary><span style="border:thin solid">header 4</span></summary>
    
    - subchild 4
    </details>
  </details>
- <span style="border:thin solid"><details><summary><span style="font-family: monospace">header 5</span></summary>
  
  - `subchild 5`<br>
    `  body 5`<br>
    `end of 5`
  </details></span>
- <span style="border:thin solid">child 6</span>
</details>

The end.
