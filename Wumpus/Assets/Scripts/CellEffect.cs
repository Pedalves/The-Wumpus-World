using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface CellEffect {

    void Action();
    void Interact();
    void Damage(int damage);
}
