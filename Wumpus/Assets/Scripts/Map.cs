using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Map : MonoBehaviour
{

    public int Width;
    public int Height;
    public float Size;
    public GameObject Cell;

    private GameObject[,] _map;

    // Use this for initialization
    void Start()
    {
        _map = new GameObject[Width, Height];
        GenerateMap();
    }

    void GenerateMap()
    {
        for(int i = 0; i < Width; i++)
        {
            for(int j = 0; j < Height; j++)
            {
                GameObject go = Instantiate(Cell, transform.position, Cell.transform.rotation, transform);
                go.transform.position += i * Vector3.right * Size;
                go.transform.position += j * Vector3.forward * Size;
                _map[i, j] = go;
            }
        }
    }
}
