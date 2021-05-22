#!/bin/bash -e

#compile and package
mvn package

#run test classes
mvn -Dexec.mainClass="ca.ualberta.stothard.cgview.CgviewTest0" -Dexec.classpathScope="test" exec:java
mvn -Dexec.mainClass="ca.ualberta.stothard.cgview.CgviewTest1" -Dexec.classpathScope="test" exec:java
mvn -Dexec.mainClass="ca.ualberta.stothard.cgview.CgviewTest2" -Dexec.classpathScope="test" exec:java
mvn -Dexec.mainClass="ca.ualberta.stothard.cgview.CgviewTest3" -Dexec.classpathScope="test" exec:java

#jar with dependencies created by mvn
CGVIEW_JAR=$(find ./target -name "*jar-with-dependencies.jar" -print -quit)

#test command-line processing of xml input
echo "Testing command-line processing of xml files in 'sample_input'."
find ./sample_input -name "*.xml" -type f | while IFS= read -r file; do
  f=$(basename "$file" .xml)
  echo "Processing file '$file'."
  java -jar "$CGVIEW_JAR" -i "$file" -f png -o ./test_maps/"${f}".png
  java -jar "$CGVIEW_JAR" -i "$file" -f svg -o ./test_maps/"${f}".svg
done

echo "Maps created in 'test_maps'."

#test command-line processing of tab-delimited input
echo "Testing command-line processing of tab files in 'sample_input'."
find ./sample_input -name "*.tab" -type f | while IFS= read -r file; do
  f=$(basename "$file" .tab)
  echo "Processing file '$file'."
  java -jar "$CGVIEW_JAR" -i "$file" -f png -o ./test_maps/"${f}".png
  java -jar "$CGVIEW_JAR" -i "$file" -f svg -o ./test_maps/"${f}".svg
done
echo "Maps created in 'test_maps'."

#test command-line creation of linked image series
echo "Testing command-line creation of linked image series."
java -jar "$CGVIEW_JAR" -i ./sample_input/xml/navigable.xml -s ./test_maps/navigable -x 1,6
echo "Maps created in 'test_maps/featureRange_element_series'."

#create cgview.jar
cp "$CGVIEW_JAR" ./target/cgview.jar

#add cgview.jar to ./bin
cp ./target/cgview.jar ./bin/

#add cgview.jar to ./docs/downloads
cp ./target/cgview.jar ./docs/downloads/

#add prokka_multicontig.gbk to ./docs/downloads
cp ./scripts/cgview_xml_builder/test_input/prokka_multicontig.gbk ./docs/downloads/

#add sample XML to ./docs/downloads
cp ./docs/xml_sample/overview.xml ./docs/downloads/
