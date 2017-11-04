using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GM : MonoBehaviour {

    public bool GameRunning;

    static private GM _instance;

    private void Awake()
    {
        if(_instance)
        {
            Destroy(gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    // Use this for initialization
    void Start ()
    {
        GameRunning = true;	
	}

    static public GM GetInstance()
    {
        return _instance;
    }
}
