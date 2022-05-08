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
import Icon from 'react-native-vector-icons/AntDesign';
import MaterialCommunityIcon from 'react-native-vector-icons/MaterialCommunityIcons';
import AsyncStorage from '@react-native-async-storage/async-storage';

const asyncStorageKey = 'recordedCursorPositions';

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

  useEffect(() => {
    AsyncStorage.setItem(
      asyncStorageKey,
      JSON.stringify(recordedCursorPositions),
    );
  }, [recordedCursorPositions]);

  useEffect(() => {
    async function restoreItems() {
      const values = await AsyncStorage.getItem(asyncStorageKey);
      if (values) {
        setRecordedCursorPositions(JSON.parse(values));
      }
    }
    restoreItems();
  }, []);

  return (
    <ScrollView>
      <View style={{flex: 1}}>
        <View style={styles.wrapper}>
          {recordedCursorPositions.map(position => {
            return (
              <View
                key={position.id}
                style={{
                  flexDirection: 'row',
                  justifyContent: 'space-between',
                  backgroundColor: '#cbd5e1',
                  marginBottom: 8,
                  padding: 8,
                  borderRadius: 8,
                }}>
                <View>
                  <Text>#{position.id + 1}</Text>
                </View>
                <Pressable onPress={() => deletePosition(position.id)}>
                  <Icon name="delete" color={'#ef4444'} size={16} />
                </Pressable>
              </View>
            );
          })}
          <View style={{marginTop: 8}}>
            <Text
              style={{fontSize: iconSize, fontWeight: 'bold', marginBottom: 4}}>
              Save
            </Text>
            <View style={{flexDirection: 'row', alignItems: 'center'}}>
              <MaterialCommunityIcon
                name="apple-keyboard-command"
                size={iconSize}
              />
              <MaterialCommunityIcon name="plus" size={iconSize} />
              <MaterialCommunityIcon
                name="apple-keyboard-shift"
                size={iconSize}
              />
              <MaterialCommunityIcon name="plus" size={iconSize} />
              <Text style={{fontSize: iconSize}}>0</Text>
            </View>
            <Text
              style={{
                fontSize: iconSize,
                fontWeight: 'bold',
                marginBottom: 4,
                marginTop: 8,
              }}>
              Move
            </Text>
            {[7, 8, 9].map(t => {
              return (
                <View
                  key={t}
                  style={{flexDirection: 'row', alignItems: 'center'}}>
                  <MaterialCommunityIcon
                    name="apple-keyboard-command"
                    size={iconSize}
                  />
                  <MaterialCommunityIcon name="plus" size={iconSize} />
                  <MaterialCommunityIcon
                    name="apple-keyboard-shift"
                    size={iconSize}
                  />
                  <MaterialCommunityIcon name="plus" size={iconSize} />
                  <Text style={{fontSize: iconSize}}>{t}</Text>
                </View>
              );
            })}
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

const iconSize = 14;

export default App;
