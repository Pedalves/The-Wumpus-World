using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisableLight : MonoBehaviour {

    private GameObject[] Lights;

    private void Awake()
    {
        Lights = GameObject.FindGameObjectsWithTag("Light");
    }

    void OnPreCull()
    {
        foreach (GameObject light in Lights)
        {
            light.GetComponent<Light>().enabled = false;
        }
    }

    void OnPostRender()
    {
        foreach (GameObject light in Lights)
        {
            light.GetComponent<Light>().enabled = true;
        }
    }
}
