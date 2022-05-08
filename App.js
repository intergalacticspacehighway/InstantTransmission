import React from 'react';
import {
  View,
  NativeModules,
  NativeEventEmitter,
  ScrollView,
  Text,
  StyleSheet,
  Pressable,
} from 'react-native';
import {useEffect, useState} from 'react';

const InstantTransmission = NativeModules.InstantTransmissionModule;
const InstantTransmissionEventEmitter = new NativeEventEmitter(
  NativeModules.InstantTransmissionModule,
);

const App = () => {
  const [recordedCursorPositions, setRecordedCursorPositions] = useState([]);

  useEffect(() => {
    let listenerOne = InstantTransmissionEventEmitter.addListener(
      'recordCursor',
      event => {
        if (recordedCursorPositions.length < 3) {
          setRecordedCursorPositions([
            ...recordedCursorPositions,
            {id: recordedCursorPositions.length, ...event},
          ]);
        }
      },
    );

    let listeneTwo = InstantTransmissionEventEmitter.addListener(
      'moveCursor',
      event => {
        if (recordedCursorPositions[event.index]) {
          const {x, y} = recordedCursorPositions[event.index];
          InstantTransmission.moveCursorTo(x, y);
        }
      },
    );

    return () => {
      listeneTwo.remove();
      listenerOne.remove();
    };
  }, [recordedCursorPositions]);

  const deletePosition = id => {
    setRecordedCursorPositions(
      recordedCursorPositions.filter(item => item.id !== id),
    );
  };

  console.log('cursors ', recordedCursorPositions);

  return (
    <ScrollView>
      <View style={{flex: 1}}>
        <View style={styles.wrapper}>
          {recordedCursorPositions.map(position => {
            return (
              <View
                style={{
                  flexDirection: 'row',
                  justifyContent: 'space-between',
                  backgroundColor: '#cbd5e1',
                  marginBottom: 8,
                  padding: 8,
                  borderRadius: 8,
                }}>
                <View key={position.id}>
                  <Text>Position {position.id}</Text>
                </View>
                <Pressable onPress={() => deletePosition(position.id)}>
                  <Text
                    style={{
                      fontWeight: 'bold',
                      fontSize: 12,
                      color: '#dc2626',
                    }}>
                    Remove
                  </Text>
                </Pressable>
              </View>
            );
          })}
          <View style={{marginTop: 8}}>
            <Text style={{fontSize: 12, fontWeight: 'bold'}}>Save</Text>
            <Text style={{fontSize: 12}}>command + shift + 0</Text>
            <Text style={{fontSize: 12, fontWeight: 'bold', marginTop: 8}}>
              Move
            </Text>
            <Text style={{fontSize: 12}}>command + shift + 7</Text>
            <Text style={{fontSize: 12}}>command + shift + 8</Text>
            <Text style={{fontSize: 12}}>command + shift + 9</Text>
          </View>
        </View>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  wrapper: {
    padding: 8,
  },
  row: {
    flexDirection: 'row',
  },
});

export default App;
