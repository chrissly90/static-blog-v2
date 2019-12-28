#!/usr/local/bin/bash
PS3='Select how to continue...'
options=("Link Single File to dir" "Relink ALL files" "Quit")
select choose in "${options[@]}"
do
  case $choose in
      "Link Single File to dir")
		  cd ../public/posts/
          echo "listing files"
		  unset options i
		  while IFS= read -r -d $'\0' f; do
		    options[i++]="$f"
		  done < <(find * -maxdepth 1 -type f -name "*.html" -print0)
		  select option in "${options[@]}" "Stop the script"; do
		    case $option in
		      *.html)
		        echo "File $option selected"
		        # processing
	            PS3='linking file to dir: '
	            options=("Computerscience" "Conspiracy Theories" "Hacktivism" "Hosting" "Posts" "Privacy" "Quit")
	            select opt in "${options[@]}"
	            do
	                case $opt in
	                    "Computerscience")
	                      cd ../cs/
	            		  ln -s ../posts/$opt .
                          echo "linked file $opt to $(pwd)"
	            		  cd ../posts/
	                      break
	                      ;;
	                    "Conspiracy Theories")
	                      cd ../ct/
	            		  ln -s ../posts/$opt.
                          echo "linked file $opt to $(pwd)"
	            		  cd ../posts/
	                      break
	                      ;;
	            		"Hacktivism")
	                      cd ../hacktivism/
	            		  ln -s ../posts/$opt .
                          echo "linked file $opt to $(pwd)"
	            		  cd ../posts/
	                      break
	                      ;;
	            		"Hosting")
	                      cd ../hosting/
	            		  ln -s ../posts/$opt .
                          echo "linked file $opt to $(pwd)"
	            		  cd ../posts/
	                      break
	                      ;;
	            		"Posts")
	            			echo "file already in directory Posts"
	                      break
	                      ;;
	            		"Privacy")
	                      cd ../privacy/
	            			ln -s ../posts/$opt .
                            echo "linked file $opt to $(pwd)"
	            			cd ../posts/
	                      break
	                      ;;
	            		"Skip")
	                      break
	                      ;;
	                    *) echo "invalid option $REPLY";;
	                esac
	            done
		        ;;
		      "Stop the script")
		        echo "You chose to stop"
		        break
		        ;;
		      *)
		        echo "This is not a number"
		        ;;
		    esac
		  done
		  cd ../../bin/
          ;;
      "Relink ALL files")
          cd ../public/posts

          for f in *
          do
            echo "Processing $f file..."
            # take action on each file. $f store current file name
            PS3='linking files to dir: '
            options=("Computerscience" "Conspiracy Theories" "Hacktivism" "Hosting" "Posts" "Privacy" "Quit")
            select opt in "${options[@]}"
            do
                case $opt in
                    "Computerscience")
                      cd ../cs/
                      rm ../cs/$f
            			ln -s ../posts/$f .
            			cd ../posts/
                      break
                      ;;
                    "Conspiracy Theories")
                      cd ../ct/
                      rm ../ct/$f
            	      ln -s ../posts/$f .
            		  cd ../posts/
                      break
                      ;;
            		"Hacktivism")
                      cd ../hacktivism/
                      rm ../hacktivism/$f
            		  ln -s ../posts/$f .
            		  cd ../posts/
                      break
                      ;;
            		"Hosting")
                      cd ../hosting/
                      rm ../hosting/$f
            			ln -s ../posts/$f .
            			cd ../posts/
                      break
                      ;;
            		"Posts")
            		  echo "file already in directory Posts"
                      break
                      ;;
            		"Privacy")
                      cd ../privacy/
                      rm ../privacy/$f
            		  ln -s ../posts/$f .
            		  cd ../posts/
                      break
                      ;;
            		"Skip")
                      break
                      ;;
                    *) echo "invalid option $REPLY";;
                esac
            done
          done
          break
          ;;
      "Quit")
          break
          ;;
      *) echo "invalid option $REPLY";;
  esac
done
